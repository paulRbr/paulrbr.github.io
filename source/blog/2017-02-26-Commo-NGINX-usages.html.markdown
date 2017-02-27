---
title: Common tricks for a good Nginx configuration
date: 2017-02-26
tags: nginx, webserver, reliability
---

After more than 3 years trusting Nginx to serve customer traffic I decided to list here a few common use cases I came up with. First in my previous working experience where I migrated the public facing webservers from Apache to Nginx. And now in my current job where I configure and maintain most of the Nginx configurations.

The following tips are **common configurations** which could easily be **reusable or useful for other people**. However all the following examples being from my experience might not be the best solution so please do not hesitate to comment my choices at the end of this article :).

READMORE

* [Configuration directory organisation](#configuration-directory-organisation)
* [Don't loose your heads](#dont-loose-your-heads)
* [If is evil but Maps are beautiful](#if-is-evil-but-maps-are-beautiful)
* [Nested named Locations](#nested-named-locations)
* [Minimal Accept-Language and User-agent parsing (without module)](#minimal-accept-language-and-user-agent-parsing-without-module)
* [Reverse proxy an existing endpoint smoothly](#reverse-proxy-an-existing-endpoint-smoothly)

## Configuration directory organisation

Organising your nginx directory is a first step to have a **clean and understandable setup**. The following paragraph is based on the already well detailed [Debian wiki page of Nginx directory structure](https://wiki.debian.org/Nginx/DirectoryStructure){:target="_blank"}.

Given the main nginx directory `/etc/nginx`,<br/> given the configuration entry file `/etc/nginx/nginx.conf`,<br/>here is my proposed directory structure for any nginx configuration.

~~~ tree
/etc/nginx/
├── nginx.conf
~~~

To serve any kind of traffic you will need to define some sites (called `vhost`s in apache) in a `sites-available` directory. The sites you want to enable will need to be symlinked in the `sites-enabled` directory. This is particularly useful if you want to disable a site temporarily: just delete the symbolic link, `reload` nginx and **you are done**.

~~~
├── sites-available
│   ├── default
│   ├── site
├── sites-enabled
│   ├── default -> ../sites-available/default
│   ├── site -> ../sites-available/site
~~~

If you need to load extra configuration files automatically the good place is the `conf.d` directory which will keep all **extra configuration files loaded in alphabetic order**. This is a good place for `upstream {}` definitions for instance.

~~~
├── conf.d
│   ├── loaded_in_alpha_order.conf
│   ├── upstream_http_api.conf
~~~

You will most probably also need configuration files which are not loaded automatically but **`include`d when needed**. A `includes.d` directory is thus a good idea to store those. You would typically store here common `ssl` settings or factorised directives. A good example if you want to include extra headers multiple times in different `location {}` blocks can be found in the [next paragraph](#dont-loose-your-heads).

~~~
├── includes.d
│   ├── include_me_later.conf
│   ├── ssl.conf
│   ├── common_headers.conf
~~~

Last but not least, as you will discover in this article: **[If is evil but `Map`s are beautiful](#if-is-evil-but-maps-are-beautiful)**. I.e. you will also need a `maps.d` directory which will contain all of your `map` definitions. Read on to see example `map` files.

~~~
├── maps.d
│   ├── conditional_logic.conf
~~~

Your `nginx.conf` entry file could thus look like the following (_WARNING_ do not copy-paste a configuration if you do not understand each line):

~~~nginx
# http://nginx.org/en/docs/ngx_core_module.html#worker_processes
# When one is in doubt, setting it to the number of available
# CPU cores is a good start (the value “auto” will try to auto detect it)
worker_processes 2;

events {
  worker_connections 1024;
}

http {
  include       mime.types;
  default_type  application/octet-stream;

  # Always check your timeout values depending of your needs
  # Default: keepalive_timeout  75s;
  keepalive_timeout  30s;

  # The timeout is set only between two successive write operations
  # Default: send_timeout 60s;
  send_timeout 10s;

  ### Other useful settings:
  ## Compress responses using gzip
  # gzip on;
  #
  ## Increase max file size upload. Defaults to 1m
  # client_max_body_size 10m;

  include conf.d/*.conf;
  include sites-enabled/*;
  include maps.d/*.conf;
}
~~~

It is a good idea to optimise general settings of your main `nginx.conf` entry point configuration file. Some good articles on [DigitalOcean's tutorials](https://www.digitalocean.com/community/tutorials/how-to-optimize-nginx-configuration){:target="_blank"} are worth reading.

## Don't loose your heads

Watch out when `add(ing)_header`s.

You could think that adding headers one by one in different subsequent blocks will keep all of them, well nope it will not. This is clearly explained in the [nginx documentation](http://nginx.org/en/docs/http/ngx_http_headers_module.html#add_header).

> There could be several `add_header` directives. These directives are inherited from the previous level **if and only if** there are no `add_header` directives defined on the current level.

If you need a common set of custom headers to use in a set of different "final" location blocks. I would recommend to keep them in an specific includable file in the `includes.d` conf directory.

As an example, here is a `includes.d/common_headers.conf` configuration file:

~~~nginx
# Add HSTS to ensure any domain and sub-domain needs to be loaded in HTTPS
add_header Strict-Transport-Security "max-age=15552001; includeSubDomains";
#
add_header X-Say-Hi "Questions? Come and say hi@example.org!"
~~~

Now let's imagine the following site definition:

~~~nginx
server {
  listen 443 ssl;
  server_name www.example.org;

  include includes.d/ssl.www.example.org.conf;

  # 1. Serve static content
  location / {
    include includes.d/common_headers.conf;

    # Add extra headers only for this location block
    add_header Pragma public;
    add_header Cache-Control "public";
    expires 7d;

    root /var/www;
  }

  # 2. Serve your public api:
  location /api {
    include includes.d/common_headers.conf;

    # Add extra headers to pass to your API backend
    add_header X-Served-By $hostname;

    proxy_pass http://http_api;
  }
}
~~~

Let's try to see the results by querying nginx for a static file

~~~bash
> curl -I https://www.example.org/style.css
...
Strict-Transport-Security: max-age=15552001; includeSubDomains
X-Say-Hi: Questions? Come and say hi@example.org!
Pragma: public
Cache-Control: public
~~~

and a dynamic content

~~~bash
> curl -I https://www.example.org/api/
...
Strict-Transport-Security: max-age=15552001; includeSubDomains
X-Say-Hi: Questions? Come and say hi@example.org!
X-Served-By: 8a31ec9f4e35
~~~

We can see that we **reused two generic headers thanks to the `include` directive** of our `common_headers.conf`  file. This obviously makes this part of the configuration DRY _(Don't Repeat Yourself)_. If we want to change one of the common header we will only need to change that file.

## If is evil but Maps are beautiful

This is the first thing you usually learn when you start playing around with an nginx configuration: _[If is evil](https://www.nginx.com/resources/wiki/start/topics/depth/ifisevil/){:target="_blank"}._

The `if` directive of nginx is part of the `rewrite` module. So you should only use it to `return` a response or `rewrite` it. **Never use an `if` around any other directive!**. Why not? Because you will probably have strange behaviors with your configuration that is very hard to debug. _It already happened to me, don't make the mistake, really :)._
If you think you need an `if` you **probably have a better solution without one**.

Indeed with time I found that most conditions can be solved with variables defined with the [`map` directive](http://nginx.org/en/docs/http/ngx_http_map_module.html). This directive can be assimilated as a `switch` / `case` statement from programming.

Whenever you need a condition in your configuration try to define a variable that will solve this condition for you through a `map`. **I recommend to organise all of your conditions in the `maps.d` conf directory where all your `map`s will live.**

E.g. let say you want to add conditions on requests' origin to differentiate your private from public interactions:

~~~ nginx
geo $geo {
  default        0;
  192.168.1.0/24 1;
  10.1.0.0/16    1;
}

# Prepare your limit req 'key'
map $geo $limit_key {
  0   $binary_remote_addr;
  1   "";
}

# Expose a private accessible counterpart of the $uri variable
map $geo $private_uri {
  0   =404;
  1   $uri;
}
~~~

Then in your site definition you don't need an `if` directive to add limiting request access only for public originated requests. Also you can define a private endpoint to serve static files without having to use an `if`. As seen in the following definitions:

~~~ nginx
# Define a limit request zone named 'api' kept in a 10 megabyte zone
# where the average request processing rate cannot exceed 5 request per second depending on the $limit key.
# I.e. rate limiting for public requests will be based on the origin IP
# and no limiting will happen for private requests.
limit_req_zone $limit zone=api:10m rate=5r/s;

location /api {
  limit_req  zone=api burst=8; # Burst after more than 8 r/s
  proxy_pass http://http_api;
}

location /private {
  root /home/internal;
  try_files index.html $private_uri;
}
~~~

## Nested named Locations

After looking quickly at the [Nginx documentation](http://nginx.org/en/docs/http/ngx_http_core_module.html#location) you could think that it is not possible to forward requests from one named location block to another named location block.

>
The “@” prefix defines a named location. Such a location is not used for a regular request processing, but instead used for request redirection. They cannot be nested, and cannot contain nested locations.

However the following side definition describes exactly **how to nest two named locations**.

~~~ nginx
location / {
  try_files $uri @first;
}

location @first {
  proxy_pass http://http_api;
  proxy_intercept_errors on;
  error_page 404 = @second;
  log_not_found off; # This is to avoid filling your error log file
}

location @second {
  proxy_pass http://http_fallback_api;
}
~~~

This can be really useful if you want to go through two different backends, one after the other, when the first doesn't know how to reply to the request.

An example of this is applied in the **current nginx configuration used to serve this website**. Static files are stored on both Github and Gitlab pages which are served as the first backend and if no files are found a dynamic backend responds on the same root location `location / {`. As you can see here:

~~~ nginx
location / {
  try_files $uri @static;
}

# First named location
location @static {
  proxy_pass        https://static-pages;
  proxy_set_header  Host $host;

  proxy_intercept_errors on;
  error_page 404 = @dynamic;
  log_not_found off;
}

# Second named location
location @dynamic {
  proxy_pass         https://dynamic-content;
  # Needed for WebSocket compat
  # https://www.nginx.com/blog/websocket-nginx/
  proxy_http_version 1.1;
  proxy_set_header   Upgrade $http_upgrade;
  proxy_set_header   Connection $connection_upgrade;
}
~~~

The upstream definitions (`static-pages` and `dynamic-content`) stored in a `conf.d/upstream_paul.bonaud.fr.conf` file looks like the following:

~~~ nginx
upstream static-pages {
  server paulrbr.gitlab.io:443;
  server paulrbr.github.io:443;
}

upstream dynamic-content {
  server paul-bonaud.rhcloud.com:8443;
  server paul2-bonaud.rhcloud.com:8443;
}
~~~


## Minimal Accept-Language and User-agent parsing (without module)

You could tell me that there is a good [nginx module](https://github.com/giom/nginx_accept_language_module) for that. However sometimes you don't especially want to recompile an nginx binary or add extra modules to it. Here is a pretty straight forward way of parsing accept-language headers to determine your users' preferred language between the languages your app supports:

~~~ nginx
map $http_accept_language $lang {
  ~(?<parsed_lang>en|fr|pt-BR) $parsed_lang;
  default                      en;
}
~~~

Yet another thing that could be solved by an extra module is user-agent parsing. If you prefer a few nginx configuration lines to parse your users' device and serve mobile ready content, here is what you could do:

Add a `maps.d/mobile_detection.conf` file:

~~~ nginx
map $http_user_agent $ua_device {
  default 'desktop';
  ~*(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge\ |maemo|midp|mmp|mobile.+firefox|netfront|opera\ m(ob|in)i|palm(\ os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows\ ce|xda|xiino/i 'mobile';
  ~*android|ipad|playbook|silk/i 'tablet';
}

map $ua_device $is_desktop {
  default   0;
  'desktop' 1;
}

map $ua_device $is_mobile {
  default  0;
  'mobile' 1;
}

map $ua_device $is_tablet {
  default  0;
  'tablet' 1;
}

map $ua_device $root_content {
  default   '/var/www/desktop';
  'tablet'  '/var/www/tablet';
  'mobile'  '/var/www/mobile';
}
~~~

_Regex source [https://gist.github.com/perusio/1326701#gistcomment-2009231](https://gist.github.com/perusio/1326701#gistcomment-2009231){:target="_blank"}_

By combining both mobile detection and language detection you can now serve different files depending on the users' user-agent AND their preferred language:

~~~ nginx
location / {
  root  $root_content;
  index index.$lang.html;
}
~~~

## Reverse proxy an existing endpoint smoothly

If you use the free version of Nginx you will not easily be able to define an **`upstream` directive pointing to different domain name `server`s**. Indeed the `upstream` module keeps a cache on the DNS resolution of the `serve` directive and you could experience a bad incident where Nginx needs to be restarted if an IP address is changed.

~~~ nginx
upstream backend {
  server dynamic.example.com:80;
}

server {
  proxy_pass http://backend;
}
~~~

Imagine you don't control the `dynamic.example.com` website and they decide to change there servers' IP. Your nginx will keep the old IP of the domain in its cache for the duration of the TTL and your own traffic will be failing.

For simple reverse proxies you can solve this by using both the [`resolver` directive](http://nginx.org/en/docs/http/ngx_http_core_module.html#resolver) and a variable definition:

~~~ nginx
server {
  resolver 127.0.0.1;
  set $backend_upstream "http://dynamic.example.com:80";
  proxy_pass $backend_upstream;
}
~~~

_Source [https://www.jethrocarr.com/2013/11/02/nginx-reverse-proxies-and-dns-resolution/](https://www.jethrocarr.com/2013/11/02/nginx-reverse-proxies-and-dns-resolution/)_

This is very convenient when you need to build an internal proxy for multiple external providers. You can define all the `server` definitions in a unique Nginx configuration and have a single entry point to use internally by your apps.

Another solution is to have the **commercial subscription of Nginx has a [`resolve`](http://nginx.org/en/docs/http/ngx_http_upstream_module.html#resolve) option** to add to your `server` definition which will monitor DNS ip changes in `upstream` definitions.

---

That's all for now! Hope you enjoyed the few tips I gathered about writing Nginx configurations. If you have any question please feel free to ask. If you see mistakes do not hesitate to let me know too. Thanks for reading until here :).
