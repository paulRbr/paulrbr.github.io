---
title: Adding Fun to the Configuration Burden
date: 2020-05-26
tags: configuration, infrastructure, deployments
---

_This blogpost was originally posted on the [Fretlink Tech blog](https://tech.fretlink.com/adding-fun-to-the-configuration-burden/) while I was working there in 2020_

Did you ever enjoy writing `XML` files by hand? *No*, OK, I thought so. Was it better with `JSON`? *No*. What about `YAML` where the indentation is so easy right? *No*, none of these are enjoyable.
The reason for all these *no* is simple: **formats** are meant to be read or written by machines and not by humans.

As computing folks we most probably prefer to write **code** because programming is what gives us the control over machines' behaviour. Follow me into the fabulous world of [programmable configuration files](https://github.com/dhall-lang/dhall-lang/wiki/Programmable-configuration-files). I'm pretty sure your will like it.

## Let's Rewrite our Deployment Configuration

In order to deploy our systems at Fretlink we use Ansible to both configure our machines (the ones we manage ourselves on a public IaaS cloud) and to deploy our services (which are deployed to a public PaaS called [Clever-Cloud](https://www.clever-cloud.com/)).

Ansible uses **a lot** of YAML. You define your tasks in YAML, you define your machine inventory in YAML and you define variables in YAML. It's easy to reach a `ETOOMUCHYAML` brain error in this situation.

Long story short, our deployments were configured through a set of variables which roughly looked like this in a `YAML` formatted file:

~~~yaml
---
# Config related to Clever-Cloud deployment
clever_app:    "app_1234"
clever_orga:   "orga_4321"
clever_secret: "{{ vault_clever_secret }}"
clever_token:  "{{ vault_clever_token }}"

clever_domian: "service1.staging.example.com"

clever_entry_point: "service-server"
clever_addons:
  - name: "pg"
    env_prefix: "POSTGRESQL_ADDON"
clever_env:
  MACAROON_SECRET:    "{{ vault_macaroon_secret }}"
  EXAMPLE_CLIENT_URL: "https://example.org/api/v1/faker"
  …
---
# Config related to our web servers
kong_servers:
  - …
~~~

The more the team grew, the more frequently we needed to change this configuration. Also, the number of our internal services was going to grow rapidly with many similarities between their configurations. And most importantly, we wanted the effort to be shared amongst the whole tech team. Environment variables are added by developers almost weekly, web server endpoints are added for new services, our system administrators adapt infrastructure related variables from time to time.

How could we manage all these changes and prevent typos? (Don't give me that look I know [you know](https://github.com/nvbn/thefuck)) How do we avoid repetition knowing that the structure of this config will be reused in all our services? How can we feel safe during a configuration refactoring?

## Down the Rabbit-Hole

Have you heard about Dhall? Not the [Indian food recipe](https://thewanderlustkitchen.com/wp-content/uploads/2016/10/quick-red-lentil-dal-dahl-5.jpg), the Dhall computer language.

> Dhall is a programmable configuration language that you can think of as: JSON + functions + types + imports
>
> &#x2014; the [Dhall-lang homepage](https://dhall-lang.org/)

Its homepage sums it up really neatly: It is a nice mix of JSON (or YAML, XML, […](https://github.com/dhall-lang/dhall-lang/wiki/How-to-integrate-Dhall#external-executable)) with **functions + types + imports**.

Let's take a peek at each of these three additional elements on top of our common formats.

### **Types**: *Why do I need types when I got free form objects* 🍸

You can optionally type any variable or records in Dhall with a colon. I.e. `let clever_app : Text = "app_1234"` will define a `clever_app` variable of type `Text` which value is `"app_1234"`.  Records can be typed too:

~~~haskell
let config : { clever_app : Text } = { clever_app = "app_1234" }
~~~

will define a `config` variable of type `{ clever_app : Text }` which value is `{ clever_app = "app_1234" }`.

Having optional types embedded in the configuration language is **key to solving many frustrations** you might have had when writing a configuration in a format like YAML. Really I am not saying this because [we like types](https://tech.fretlink.com/about-our-tech/) at Fretlink, I am saying it because it saved us a lot of time. As part of the devoups team, we are expert on text typos and Dhall transforms those into proficient tty-ops. So let's take some time to explain why:

1.  First reason is to ensure type safety **on values**. In a YAML file, for instance, you can write `Text` values with or without quotes. `clever_app: "app_1234"` is as valid as `clever_app: app_1234`. It will even let you write `clever_app: 1234` and you could imagine that `1234` will be interpreted as a string. However most systems reading this will parse it as an `Integer` instead of a `Text` without you noticing.

    <caption><i>👋 What could go wrong while summing integers and texts in Javascript?</i></caption>

    ~~~javascript
    > 1 + 1 + 1
    3
    > 1 + 1 + "1"
    "21"
    > 1 + "1" + "1"
    "111"
    ~~~

2.  Our new anti-typos hero is here to offer type safety **on data structure**. This is where Dhall shines because you can define complex record types where each field name in your record values will be statically checked for free!

    Did you spot the error in the `YAML` configuration file earlier on? If you were concentrated and have good eyes you probably did. If you didn't spot it, we made a typo and wrote `clever_domian:` instead of `clever_domain:`. Let's let the Dhall language check that for us by defining a `CleverConfig` type and use it in our configuration:

    ~~~haskell
    -- Define our CleverConfig record type
    let CleverConfig =
          { clever_app : Text
          , clever_orga : Text
          , clever_secret : Text
          , clever_token : Text
          , clever_domain : Optional Text
          }
    
    -- Define our record value of type 'CleverConfig'
    in    { clever_app = "app_1234"
          , clever_orga = "orga_4321"
          , clever_secret = "{{ vault_clever_secret }}"
          , clever_token = "{{ vault_clever_token }}"
          , clever_domian = Some "service1.staging.example.com"
          }
        : CleverConfig
    ~~~
    
    What happens if we ask dhall to type check this expression?
    
    ~~~
    Error: Expression doesn't match annotation

    { - clever_domain : …
    , + clever_domian : …
    , …
    }
    ~~~
    
    Pretty nice ain't it? **Of course it works with any complex record structure with as many sub-records as you like.**

### **Imports**: *One single file can do just fine don't worry* 😁

As you would expect from a traditional programming language you can factorise code into separate files and use imports to link them together. No need for [each](https://docs.gitlab.com/ce/ci/yaml/#include) and [every](https://docs.ansible.com/ansible/latest/modules/include_module.html) tool to implement their own `include:` function on top of the formats they use, the feature is embedded in the configuration language itself.

Taking our example from above we could then separate the type definition and the configuration record:

<center><i><code>CleverConfig.dhall</code> file</i></center>

~~~haskell
{ clever_app : Text
, clever_orga : Text
, clever_secret : Text
, clever_token : Text
, clever_domain : Optional Text
}
~~~

<center><i><code>clever.dhall</code> file</i></center>

~~~haskell
-- Import our record type from a local file
let CleverConfig = ./CleverConfig.dhall

in    { clever_app = "app_1234"
      , clever_orga = "orga_4321"
      , clever_secret = "{{ vault_clever_secret }}"
      , clever_token = "{{ vault_clever_token }}"
      , clever_domain = Some "service1.staging.example.com"
      }
    : CleverConfig
~~~

You can import a `*.dhall` expression from a local file, a remote file or even from an environment variable. Here are the three simple constructs to do so:

- `./types.dhall` to load a local file
- `https://example.org/types.dhall` a simple URL to load a remote file
- `env:FOO_VARIABLE` load dhall expression from an environment variable (very uncommon way to use imports)

### **functions**: *I don't need functions in YAML because I have anchors and aliases* 😎

Did you know YAML let's you define anchors on an object with  `&anchorName` and reuse this object with the alias `*anchorName`? It's a first step to factorise some common configuration.

~~~yaml
.common: &cleverAnchor
  clever_secret: "{{ vault_clever_secret }}"
  clever_token: "{{ vault_clever_token }}"
  clever_orga: "orga_4321"

services:
  - <<: *cleverAnchor
    clever_app: "app_1234"
    clever_domain: "service1.staging.example.com"
  - <<: *cleverAnchor
    clever_app: "app_6789"
    clever_domain: "service2.staging.example.com"
~~~

In a more programmatic way we could define a constructor function and call it for each service. Such a Dhall function would look like this:

~~~haskell
-- Reuse our CleverConfig type defined earlier
let CleverConfig = ./CleverConfig.dhall

-- Function definition
let mkConfig =
        λ(app : Text)
      → λ(domain : Optional Text)
      →   { clever_app = app
          , clever_orga = "orga_4321"
          , clever_secret = "{{ vault_clever_secret }}"
          , clever_token = "{{ vault_clever_token }}"
          , clever_domain = domain
          }
        : CleverConfig

in  { services =
        [ mkConfig "app_1234" (Some "service1.staging.example.com")
        , mkConfig "app_6789" (Some "service2.staging.example.com")
        ]
    }
~~~

That's our syntax to write functions in Dhall:

`λ(…a typed parameter…) → λ(…another parameter…) → …function body…`

(Don't worry you don't *need* to use the λ and → Unicode characters, you can replace them with `\` and `->` respectively)

## \o\ No More `YAML` Woop Woop /o/

We thus decided to use Dhall to replace the deployment steps of our services' continuous integration workflow. It was a perfect place to start as those configuration lie in each of our service's repository and we want everybody to be able to make changes to it (not only the *devoups* team).

We were so happy with our new toy that we started using functions, imports and types everywhere in order to transform this `YAML` configuration into *awesome code*. We wanted to make it generic, we wanted to make it look like software.

However, we quickly realised we had lost ourselves and ended up having a wonderful world of type-safe configuration but more importantly a **completely un-maintainable one**.

<center><i>Logic everywhere, such wow, much complex</i></center>

    dhall/
    ├── deployment
    │   ├── ansible
    │   │   ├── hosts
    │   │   ├── mkClever.dhall
    │   │   └── mkKong.dhall
    │   ├── Global.dhall
    │   ├── mkConfigs.dhall
    │   ├── mkGlobal.dhall
    │   ├── mkPG.dhall
    │   ├── mkVault.dhall
    │   ├── Types.dhall
    │   ├── Vault.dhall
    │   └── vault.dummy.dhall
    ├── external-functions.dhall
    ├── external-types.dhall
    ├── Makefile
    ├── production
    │   ├── clever.dhall
    │   ├── Configs.dhall
    │   ├── hosts.dhall
    │   ├── kong.dhall
    │   ├── pg.dhall
    │   └── vault.dhall.enc
    ├── production.dhall
    ├── staging
    │   ├── clever.dhall
    │   ├── Configs.dhall
    │   ├── hosts.dhall
    │   ├── kong.dhall
    │   ├── pg.dhall
    │   └── vault.dhall.enc
    ├── staging.dhall
    └── shell.nix
    
    4 directories, 30 files

Yes, yes, this is the directory structure of our first try at using Dhall to replace 62 lines of `YAML` (31 lines per env, staging and production).

With this kind of configuration in place, what happens when someone wants to *change the staging environment Kong configuration* for instance? We could think it's easy and go into the `dhall/staging/kong.dhall` file right?
Well not really because it contains only generic logic to call a function called `mkKong` with the `Staging` environment type as input parameter. Ok, let's open the file `dhall/deployment/ansible/mkKong.dhall` then. Again we can't find the URL we wanted to change initially. This is becoming *annoying*, to say it politely. Apparently the URL is given by the `mkGlobal` function. Let's look in the `dhall/deployment/mkGlobal.dhall` file. Victory! The configuration change we wanted to do can be done here. 😅

You understood, we had clearly gone too far. Worst of all, our devoups team member couldn't make a quick change in case of a production emergency. This was really not what we had intended.

## Back to Basics

Our main goal had always been to enhance our team work on configuration changes and make it much more friendly to look at, even for newcomers, and much more safe to update. We knew Dhall would help by giving us all the nice features mentioned above. But we still didn't know how to mold it to our needs. After a few internal discussions, improvements in the dhall language along the way (E.g. support for [mixed kinds records](https://github.com/dhall-lang/dhall-lang/pull/689) giving the ability to encapsulate Types and record values into one single record helped us to build easily exportable “packages”) and incremental changes in our code we finally found our sweet spot.

One of the key insights was to focus on **avoiding the usage of functions to build records**. Instead we focused on offering abstraction layers which take as inputs a plain old record of all needed values. Of course we still want to hide some field names that are specific to our tools, but with just enough abstraction to still give flexibility to the underlying service configuration's need.

In our case this translated into implementing two abstraction layers:

- Dhall “interfaces” inside our Ansible roles (we have one for the Clever-Cloud configuration and another one for the Kong configuration) which exports generic types and their associated constructors in order to match the role's available configuration.
- A common Fretlink dedicated layer to gather our services' defaults into one place. This common layer being responsible to manipulate the generic types inherited from our Ansible roles and export helper functions to the services. For example, parts of the configuration which are not directly interesting for developers can be hiden away inside *default* (or *common*) constructor functions.

Enough talking, let's dig into the example for the Clever configuration part of our `YAML` deployment configuration defined in the beginning of the article.

<center><i><code>ansible/inventories/staging/group_vars/all/vars.yml</code></i></center>

~~~yaml
---
# Config related to Clever-Cloud deployment
clever_app:     "app_1234"
clever_orga:    "orga_4321"
clever_secret:  "{{ vault_clever_secret }}"
clever_token:   "{{ vault_clever_token }}"

clever_domain: "service1.staging.example.com"

clever_entry_point: "service-server"
clever_addons:
  - name: "pg"
    env_prefix: "POSTGRESQL_ADDON"
clever_env:
  MACAROON_SECRET: "{{ vault_macaroon_secret }}"
  EXAMPLE_CLIENT_URL: "https://example.org"
  …
~~~

The generic Clever related layer describes record types with their constructors and is maintained as part of the Ansible role:

<center><i><code>https://raw.githubusercontent.com/fretlink/ansible-clever/master/dhall/package.dhall</code></i></center>

~~~haskell
let Addon =
      < Postgresql : { name : Text, env_prefix : Text }
      | Redis : { name : Text, env_prefix : Text }
      -- … all compatible Clever addons
      >

let Config =
      { clever_app : Text
      , clever_orga : Text
      , clever_secret : Text
      , clever_token : Text
      , clever_domain : Optional Text
      , clever_entry_point : Optional Text
      , clever_addons : List Addon
      , clever_env : {}
      }

let mkConfig =
        λ(vault : Vault)
      → λ(app : Text)
      → λ(organization : Text)
      →   { clever_app = app
          , clever_orga = organization
          , clever_secret = vault.secret
          , clever_token = vault.token
          , clever_domain = None Text
          , clever_entry_point = None Text
          , clever_addons = [] : List Addon
          , clever_env = {=}
          }
        : Config

in  { Config =
        { Type = Config
        , mkConfig = mkConfig
        }
    , Addon =
        { Type = Addon
        , postgresql =
            Addon.Postgresql { name = "pg", env_prefix = "POSTGRESQL_ADDON" }
        }
    }
~~~

Then, the Fretlink abstraction layer exposes a `mkDefaultConfig` function which fits with our services' defaults:

<center><i><code>https://commons.fretlink.com/package.dhall</code></i></center>

~~~haskell
-- Import the role package
let Clever = https://raw.githubusercontent.com/fretlink/ansible-clever/master/dhall/package.dhall

--
-- variables hidden away for clarity in this article
--     (Environment, ApplicationData and mkDefaultEnv)
--

let mkDefaultConfig =
        λ(environment : Environment)
      → λ(appData : ApplicationData)
      → let defaultAddons = [ Clever.Addon.postgresql ]

        let baseData : Clever.Config.Type
            = Clever.Config.mkConfig
                appData.cleverSecrets
                appData.appId
                appData.orgId

        in    baseData
            -- Merge Fretlink defaults with the '∧' operator
            ∧ { clever_entry_point = appData.entryPoint
              , clever_domain = appData.domain
              , clever_addons = appData.additionalAddons
              , clever_env = mkDefaultEnv environment appData
              }

in  { Clever = { mkDefaultConfig = mkDefaultConfig } }

~~~

And finally the Dhall code within the service repository which generates the exact same YAML defined above:

~~~haskell
-- Import the Fretlink dhall commons package
let Fretlink = https://commons.fretlink.com/package.dhall

in    Fretlink.Clever.mkDefaultConfig
        (Staging {=})
        { cleverSecrets = vault.clever
        , serviceSecrets = vault.service
        , appId = "app_1234"
        , orgId = "orga_4321"
        , entryPoint = "service-server"
        , domain = "service1.staging.example.com"
        }
    -- Merge service specific configuration with the '∧' operator
    ∧ { clever_env = { EXAMPLE_CLIENT_URL = "https://example.org" } }
~~~

What do we notice here? Parts of the configuration is abstracted away such as:

-   the details of `clever_secret` and `clever_token` fields are replaced by a unique `cleverSecrets` record (which is typed in the `vault` variable to make sure it includes the secret and the token)
-   the details of `clever_addons` is completely missing. Why? Because, by default, all of our services have a PostgreSQL addon and this logic is received by the Fretlink common layer.
-   parts of the details of `clever_env` is missing. Why? Similarly to the previous point, by default all of our services have a `MACAROON_SECRET` variable and the Fretlink common layer construct it for us.

With these dhall files you can discover the `∧` operator (don't worry you can write `/\` without Unicode) which is a way to recursively merge records. I.e. the `mkDefaultConfig` function produces a record which already has a `clever_env` keyed value and we “override” it by merging a record with the same `clever_env` key containing the service specific values.

If we take a look at our new directory structure, it feels much more welcoming and understandable.

    deployment/
    ├── import.dhall
    ├── Makefile
    ├── production
    │   ├── configuration.dhall
    │   └── vault.dhall.enc
    ├── production.dhall
    ├── staging
    │   ├── configuration.dhall
    │   └── vault.dhall.enc
    ├── staging.dhall
    ├── shell.nix
    └── Vault.dhall
    
    2 directories, 15 files

Overall all the important configuration values for each environment are now in **one single file**. Generic logic which doesn't hold project specific configuration is abstracted away and included via the `import.dhall` file. Now, if we want to *change the staging environment Kong configuration* we can simply open up the `deployment/staging/configuration.dhall` file and be sure to find everything related to the `Staging` environment and specific to our service in there. ☺️


## Going even Further

Removing Ansible's specificities from the configuration was achieved ✓.

On top of the improvements mentioned above, this also means we don't even need to worry about each tools' templating engine (in our case, no need to use Ansible's Jinja templating engine anymore 🤩). With Dhall we have a fully fledged functional programming language and text interpolation if needed. If you are curious about the Dhall syntax for text interpolation within strings it is done with `${variable}`.

~~~haskell
let planet = "earth"

let greeting = "Hello ${planet}"

in  greeting
~~~

will result in the string `"Hello earth"`.

However we still had our secret variables inside Ansible specific encrypted files. Did you notice the `vault.dhall.enc` files in the resulting directory structure of our deployment configuration?  In order to try to be a bit less tied up to Ansible, and replace its `ansible-vault` binary, we decided to use a more common encryption tool: `openssl-enc`.

These are our encrypting/decryption tasks which are enough to fill this need (GNU Make syntax):

~~~makefile
.PHONY: encrypt
encrypt: ## make encrypt ENVIRONMENT_NAME=staging # Encrypt the dhall $(ENVIRONMENT_NAME)/vault.dhall file with the VAULT_PASS_$(ENVIRONMENT_NAME) secret
	openssl enc -aes-256-cbc -md sha256 \
        -pass "env:VAULT_PASS_$(ENVIRONMENT_NAME)" \
        -in "$(ENVIRONMENT_NAME)/vault.dhall" \
        -out "${ENVIRONMENT_NAME}/vault.dhall.enc" \
        -base64

.PHONY: decrypt
decrypt: ## make decrypt ENVIRONMENT_NAME=staging # Decrypt the encrypted $(ENVIRONMENT_NAME)/vault.dhall.enc file with the VAULT_PASS_$(ENVIRONMENT_NAME) secret
	openssl enc -d -aes-256-cbc -md sha256 \
        -pass "env:VAULT_PASS_$(ENVIRONMENT_NAME)" \
        -in "$(ENVIRONMENT_NAME)/vault.dhall.enc" \
        -out "$(ENVIRONMENT_NAME)/vault.dhall" \
        -base64
~~~

## This is Too Good to be True

I could finish this article without mentioning any downsides of Dhall, but that would make you doubt all the positives. OK, so what are the pitfalls of using Dhall?

Well, in order to enjoy type checking, data structure checking, factorisation on any configuration files you will **need a build process**. Indeed from the `.dhall` source code you will need to run the `dhall-to-*` executable (where `*` stands for any formats for which a [conversion executable exist](https://github.com/dhall-lang/dhall-lang/wiki/How-to-integrate-Dhall#external-executable)) to generate the end configuration file.

For instance, most available continuous integration services out there will ask for a  `*.yml` file in your git repository (`.circleci/config.yml`, `.gitlab-ci.yml`, Github Actions, …) so you can forget about running your automatic builds using Dhall only. Of course your could set a local build hook to generate the `*.yml` file before commiting but that would defeat the “full automation” purpose of continuous integration tools.

To mitigate this pitfall, lots of different language community based libraries offer an implementation of the Dhall language of their own. So you could enjoy Dhall to configure your [Rust](https://github.com/Nadrieril/dhall-rust) service, your [Ruby](https://git.sr.ht/~singpolyma/dhall-ruby) service or your [Haskell](https://github.com/dhall-lang/dhall-haskell) service (Dhall-lang's official implementation is the Haskell one so, that was easy 👌). With this in mind you can directly read your Dhall configuration within your own codebase without the need to generate any intermediate JSON or YAML files. Oh boy, is this Dhall language real after all?

I hope I convinced you to give it a try. Dhall language is continuously evolving thanks to the wonderful work of [Gabriel Gonzalez](https://github.com/Gabriel439) and the dhall community. Once you arrived in _the good place_ you'll never want to go back to writing in primitive machine formats.

Have fun, stay free and stay kind.

✨

<style>
  .post-full-content p code { word-break: break-word !important; white-space: nowrap; }
</style>
