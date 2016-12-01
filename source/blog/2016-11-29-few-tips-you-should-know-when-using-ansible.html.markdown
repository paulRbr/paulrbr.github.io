---
title: "Ansible: a few tips from my experience"
date: 2016-11-29
tags: ansible, automation, configuration management
---


After using [Ansible](https://github.com/ansible/ansible) in a pretty big [production platform](https://www.captaintrain.com/) I wanted to try to list here a few tips worth sharing for both beginners and regular Ansible users.
READMORE

If you don't know what Ansible is, the github description is pretty clear:

> Ansible is a radically simple IT automation platform that makes your applications and systems easier to deploy. Avoid writing scripts or custom code to deploy and update your applications— automate in a language that approaches plain English, using SSH, with no agents to install on remote systems.

## 1. Divide your inventory by environment

An **inventory** is a file which lists all of your **hosts** ordered into **groups** (you may specify groups of groups). A good directory organization is to divide your inventory by environments.

This is actually explained in Ansible's [documentation](http://docs.ansible.com/ansible/playbooks_best_practices.html#alternative-directory-layout) but it is good to paraphrase.

_Wait a minute my inventory is never fixed I have a cloud based infrastructure!_

Don't worry dynamic inventories are easy to manipulate in Ansible. Just add an executable python script in the root folder of your inventory and your done! Lots of existing ones are already provided by Ansible, just pick the one for your needs: [Amazon EC2](https://github.com/ansible/ansible/blob/devel/contrib/inventory/ec2.py), [Google CP](https://github.com/ansible/ansible/blob/devel/contrib/inventory/gce.py), [Digital Ocean](https://github.com/ansible/ansible/blob/devel/contrib/inventory/digital_ocean.py), even connecting to a [Docker](https://github.com/ansible/ansible/blob/devel/contrib/inventory/docker.py) daemon and [many more](https://github.com/ansible/ansible/tree/devel/contrib/inventory). This is actually great for a mixed static and dynamic infrastructure as you can group inside your inventory file both **static groups** and **dynamic groups**.

So as I said, I really advise you to **separate your different environments into different "inventory directory"**:

~~~ yaml
integ/
  hosts        # ← inventory file containing integration servers

prod/
  hosts        # ← inventory file containing production servers
~~~

You will then be sure to never mix **integration** hosts into your **production** inventory. Also it will be easy for you to factorize some variables that are environment agnostic.

Imagine you have a `webserver` **group**. This _group_ notion has nothing _environment_ related: it is a group that exists for all of your environments. You will thus be able to store variables in your directory structure like this:

~~~ yaml
integ/
  host_vars/   # ← Host specific variables

  group_vars/
    webserver/
      vars.yml # ← Integration env specific variables
  hosts        # Integration inventory

prod/
  host_vars/   # ← Host specific variables

  group_vars/
    webserver/
      vars.yml # ← Production env specific variables
  hosts        # Production inventory

group_vars/
  webserver/
    vars.yml   # ← Variables common to all envs
~~~

The set of all those variables files will be your **infrastructure's configuration data**.
If you come from the Puppet world, this set of files can be compared to [Hiera](https://docs.puppet.com/hiera/)'s configuration data.

The main difference with Hiera is that the order of precedence is implicit. And that's a great way to simply your configuration!

Indeed most of the time Ansible's precedence of variables is as you would expect it to be (i.e. a host specific variable is more important than a group specific variable). The complete list of variable precedence is available [here in the documentation](http://docs.ansible.com/ansible/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable).

## 2. Try to use community Roles from Galaxy

A **Role** _(I like to call them modules)_ contains a list of tasks to operate on your hosts in order to administrate a service. Those **roles** are parametrized by your inventory **variables** when being ran against your **inventory**.

**Whenever you can, try to use roles developed by the community.**

Want to install Nginx? Redis? Your favorite database software?

Most of the time a role has already been developed by great people. Explore Ansible's [galaxy site](https://galaxy.ansible.com/list#/roles) you will probably find something useful.

## 3. Tags + Groups for the win!

Now that you have selected some **roles** you will want to compile them into a **playbook**. A good thing to do when you use a role is to always **define a group condition and a tag name**. Let me explain..

The **group condition** gives a good way to limit the execution of certain roles. So you are sure the role is not applied if your server is not part of a certain **group**.

The **tag name** is a great way to test your playbooks. Indeed, when you want to apply only parts of it you will be happy to have tagged all your roles.

For instance,

~~~ yaml
# setup.yml playbook file
- roles:
  - role: common
    tags: [ common ]

  - role: nginx
    tags: [ webserver ]
    when: "{{ 'webserver' in group_names }}"

  - role: postgresql
    tags: [ database  ]
    when: "{{ 'database'  in group_names }}"
~~~

With this list of roles inside your playbook, you will now easily be able to isolate the `database` related tasks by passing the `--tags database` argument to Ansible.

`ansible-playbook --tags database setup.yml`

You have noticed the condition on both the `nginx` and `postgresql`. Imagine you have a server `db01` which is **not** part of your `webserver` **group** inside your **inventory**. By mistake you try to apply the related `webserver` tasks to this server. The **group condition** will save you as you can see on the logs bellow (see the `skipping:` output):

~~~ yaml
# ~> ansible-playbook --limit db01 --tags webserver setup.yml

PLAY [all] ****************************************************

TASK [nginx : Include OS-specific variables.] *****************
skipping: [db01]

TASK [nginx : Define nginx_user.] *****************************
skipping: [db01]

TASK [nginx : Enable nginx repo.] *****************************
skipping: [db01]

TASK [nginx : Ensure nginx is installed.] *********************
skipping: [db01]

...
~~~



## 4. Simple interface for easy wide adoption

I will [again](paul.bonaud.fr/2016/09/Building-apps-with-docker.html#a-realistic-and-proven-use-case) thank my friend and ex-colleague [Pierre](https://twitter.com/pmorinerie) for his nice article about [standardizing projects with Makefiles](https://blog.trainline.eu/13439-standardizing-interfaces-across-projects-with-makefiles). If you have never read it you should take a look at it. It is really great when working with multiple projects.

If we try to apply this philosophy to an ansible configuration project we can define a few tasks that we will often do:

* install dependencies from a dependency file with `make install`

~~~ makefile
install: ## Install roles dependencies
	ansible-galaxy install --roles-path vendor/ -r requirements.yml
~~~

* check your playbook's syntax with `make lint`

~~~ makefile
lint: ## Check syntax of a playbook
	ansible-playbook --syntax-check $(opts) $(playbook).yml
~~~

* debug a host's variables with `make debug host=db01`

~~~ makefile
debug: ## Debug a host's variable
	ansible $(opts) -m debug -a "var=hostvars[inventory_hostname]" -i hosts $(host)
~~~

* dry run a playbook with `make dry-run playbook=setup`

~~~ makefile
dry-run: ## Run a playbook in dry run mode
	ansible-playbook --diff --check $(opts) $(playbook).yml
~~~

* Once your happy with your dry run, just run it with `make run playbook=setup`

~~~ makefile
run: ## Run a playbook
	ansible-playbook --diff $(opts) $(playbook).yml
~~~

Feel free to check my complete current [Makefile](https://github.com/paulRbr/ansible-makefile/blob/master/Makefile) settings for my ansible managed projects. It is probably not perfect but it is a good start. If you feel some things are missing, contributions are very welcome.

It is now really easy to test one of my playbook and I don't need to remember to put the `--check` or `-C` flag each time:

~~~ bash
# ~> make dry-run playbook=deploy
ansible-playbook --diff --check deploy.yml
~~~

I can also pass in ansible extra arguments in an `args` parameter:

~~~ bash
# ~> make dry-run playbook=deploy args="--limit app1"
ansible-playbook --diff --check --limit app1 deploy.yml
~~~

## 5. Use Ansible's vault to store encrypted variables

Inside your infrastructure's configuration data you will probably not want to save sensitive information in clear. **Use Ansible's vault!**

**I really recommend all of the following:**

* **Separate vault passphrase per environment**: you really do not want your integration passphrase to decrypt your sensitive production data.
* **Prefix vaulted variables** by `vault_` and use these within your non vaulted files. This is for clarity when reading the data variable files. Someone picking up your data file later on will clearly see that your variables has a vaulted value without the need to decrypt the vaulted file to understand that. E.g.

~~~ yaml
# clear text vars.yml file
strong_password: "{{ vault_strong_password }}"
~~~

~~~ yaml
# Encrypted content of the vault_vars.yml file
#
# vault_strong_password: "my_secret_content"
#
$ANSIBLE_VAULT;1.1;AES256
326338613161366139376638
376135313138646232336666
643566303265393938643631
53332623863383133862
~~~

* As seen in the previous point: **prefix vaulted filenames** by `vault_` and associate them with the non vaulted counterpart file. `vars.yml` and `vault_vars.yml` for instance
* Use a **single entry point script** to output the passphrase (pass.sh)
* **Use `no_log: true`** for every task that interacts with a vaulted variable. This will ensure to not output any sentive information in your ansible logs.

## 6. Agent-less tool: you need a good and automated build pipeline

This is really important. Especially if you want to introduce Ansible in an **existing platform**.

Indeed if you have servers that were manually setup in your infrastructure you will probably miss some configuration out when you start building your playbooks. So if you don't pay attention you could override a configuration file that was never inside your version control system and loose the previous configuration state of the server.

**This is why you really need both the following:**

* At least one **integration/testing environment**. It seems obvious but you should always have an integration environment were you pick up the bugs before going to production.
* A **build pipeline for continuous integration/delivery**. It will be great to log all the changes made by Ansible. So in case you get in troubles you will have it all logged in a centralized place.

Let me explain in greater detail the second point. You really need to have **all of your playbooks running automatically in your build pipeline** first applied to your integration inventory and then to your production one. Playbooks should run **without any limitation of hosts**, no `--limit` param please 😊. Well you can use `--limit` argument if you have an exhaustive set of builds that will span throughout your entire inventory.

For the production deployment, I recommend a **`dry-run` to run automatically in your build pipeline**. Once you have reviewed the changes mentioned by the `dry-run` logs, a manual step clicking on a button for production `run` is a good thing IMHO. (Gitlab is great for [manual steps](https://gitlab.com/gitlab-org/gitlab-ce/issues/17010) within your build pipeline by the way).

## Recap

#### 1. Divide your inventory by environment

#### 2. Try to use community roles from Galaxy

#### 3. Tags + Groups for the win!

#### 4. Simple interface for easy wide adoption

#### 5. Use Ansible's vault to store encrypted variables

#### 6. Agent-less tool: you need a good and automated build pipeline
