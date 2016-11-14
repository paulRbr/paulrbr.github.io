---
title: Notes from my journey at Velocity conf 2016 (Europe)
date: 2016-11-09
tags: conference, velocity, Amsterdam, people
skip_to_link: { talks: "Skip directly to the talks transcripts 📝" }
---

I had the chance to attend [Velocity conf 2016](http://conferences.oreilly.com/velocity/devops-web-performance-eu){:target="_blank"} in Amsterdam thanks to my current employer [Trainline](https://www.trainline.eu/about/us){:target="_blank"} (formerly Capitaine Train). This article is a minimal transcript of my journey there during the talk sessions.

READMORE

## Big venue, big conference: better than expected

First of all it was my first "sponsored big tech conference" experience. I personally like independent ones - which usually tries to be as inclusive as possible - but I have to say I was really happy to see the diverse lineup of speakers at Velocity.

The venue in the south of Amsterdam was really impressive (even though some attendees told me it was 4 times smaller than the same conf in California). I have to say it is a good way to share talks and experiences to many different attendees.

Even if I know it requires lots of planing and lots of money to organize, I felt bad that this conference has a high price entry. I wish it was more accessible and that people without a company behind them could afford attending such a conference. This is why I decided to publish my notes here. Beware though they are my personal notes so they might not be as clear as I wish they could be. Feel free to contact me if you have doubts. The videos of the talks should be published in a couple of weeks if you desire.

## Talks

I especially appreciated the talks of [Avleen Vig](#avleen-vig) talking about burnouts in our industry, [Adam Surak](#adam-surak) about server reliability, [George Sudarkoff](#george-sudarkoff) about ops teams, [Astrid Atkinson](#astrid-atkinson) about building great teams, [Guy Podjarny](#guy-podjarny) about open source security, [Amanda Folson](#amanda-folson) about how oncall sucks and finally (clearly not least) [Mathias Meyer](#mathias-meyer) about distributed teams.

Enough of my thoughts, let's jump into the notes.

First day:

* [Steven Shorrok](#steven-shorrok)
* [Yoav Weiss](#yoav-weiss)
* [James Duncan](#james-duncan)
* [Jason Grigsby](#jason-grigsby)
* [Avleen Vig](#avleen-vig)
* [Adam Surak](#adam-surak)
* [Radu and Rafal](#radu-and-rafal)
* [George Sudarkoff](#george-sudarkoff)
* [Björn Rabenstein](#bjrn-rabenstein)

Second day:

* [Astrid Atkinson](#astrid-atkinson)
* [Eric McNulty](#eric-mcNulty)
* [Phil Stanhope](#phil-stanhope)
* [Guy Podjarny](#guy-podjarny)
* [Mandi Walls](#mandi-walls)
* [Cynthia Mai](#cynthia-mai)
* [Amanda Folson](#amanda-folson)
* [Mathias Meyer](#mathias-meyer)

## First day

### Steven Shorrok

[@stevenshorrock](https://twitter.com/stevenshorrock){:target="_blank"}

In a context of your work, there is usually two different vision about the actual work:

* Work as imagined
* The work as done

There is usually a small overlap but the operating zone is pretty different.

E.g. with aircraft pilots. ECAM (monitoring tool) failing: pilots have
judgment. Yes machine can process data quicker than us but can't have
judgment.

E.g.2 NHS UK "target-driven": nurses in hospital had 4 hours to have a
patient sent home. Nurses found a way to bypass this "imagined
work" by registering a patient in different zones when needed.

> "Targets always result in gaming" **Simon Caulkin**

**Solutions?**

* Reactive policies. Include reviewing policy after postmortems.x
* Discuss gaps between imagined and done. Via (no/pre/post)mortems.

[↑ Back to the list of talks](#talks)

---

### Yoav Weiss
_Akamai_

[@yoavweiss](https://twitter.com/yoavweiss){:target="_blank"}


W3C Web Performance Working Group (browser APIs)

What's a WG?

* Group of engineers across big corps.
* Communicate online & git repos

What they've been doing? APIs to measure. You can't improve what you can't measure. E.g. Performance data from users.

* Navigation Timing
* Resource Timing
* User timing
* Beacon (send data back to server even if the user decides to close the
web page)

Hints

* Preconnect (DNS, TLS connection before the resource is needed) `<link
rel=preconnect..>`
* Preload `<link
rel=preload..>`

Next?

* Visual metrics
* First Paint & First Contentful Paint
* Hero Element API. Apply custom metrics on other things than JS (html,
css..)
* Long Task Observer (Browser unavailable for user)
* Input latency

How to influence the WG?

* Feedback please (w3c github, discourse wicg.io). Love or hate.

[↑ Back to the list of talks](#talks)

---

### James Duncan
_UK Government Digital Service_

[@jamesaduncan](https://twitter.com/jamesaduncan){:target="_blank"}

"Any sufficiently advanced technology is indistinguishable from magic"

* Experimental edge != working people
* Pad planning, pad money → pad ambition
* Failure greatest place to learn
* People with the money decides for the people doing the work
* Big corp: little by little towards a complex network of people and
technology.
* Is technology an obvious response to technology issues? No it should not be!
* Exponential growth is the goal of entrepreneurship. This is not the only parameter for success. But 1% of growth is still a success it's good!
* How to we experience the world? One search away, we all know everything
about anything.
* Facts != Expertise

[↑ Back to the list of talks](#talks)

---

### Jason Grigsby
_Cloud Four_

[@grigs](https://twitter.com/grigs){:target="_blank"}

Building progressive webapps

* Gap from website to native apps
* Push notifs
* Performance
* Not iOS. However works with any browsers.

He is so happy about PWA. Go out and build PWA now.

[↑ Back to the list of talks](#talks)

---

### Avleen Vig
_Etsy_

[@avleen](https://twitter.com/avleen){:target="_blank"}

[slides](http://www.slideshare.net/avleenvig/dont-burn-out-or-fade-away){:target="_blank"}

Burnout in Engineering

Occupational Burnout. What it's not?

* Feeling tired
* Unhappiness
* Feeling bored

So what it is? 3 concurrent symptoms (all together):

* exhaustion
* Cynicism
* Inefficacy

90% of occupational burnout → Similar to clinical burnout

What should we take a look at?

* Manageable **workload**
* **Fairness**
* Job control (**no micro management**)
* **Values**
* **Reward**
* **Community**

Easy solution:

* Work Less!
* No it's not a solution duuuh

Common steps towards burnout:

1. Compulsion to prove yourself. Stay late one night a week, then two, then three.. Then start to ignore priorities.
1. Working harder
1. Ignoring priorities
1. Start to blame others
1. There can be no failure
1. Start blaming your workload
1. Start dreaming abt ur job (been already a few months)
1. Others start to notice some changes in your behavior. But you don't believe them
1. You can't get any work done
1. Emotional emptiness (depression starts here and sometime need professional help at this point)

Personal burnout of Avleen: (June 2013)

* Simple project: replace proprietary software with an open-source system
* Good learning curve
* Started working a few late nights
* It's ok it's an important project
* Only one person on project. bzzz ← **This is already a bad decision**
* **Sept 2013**
* Can't sleep in every day.
* Family picks up things I used to do at home
* Same at work
* **Dec 2013**, exhaustion is in full effect
* Learning phase finished, I understand how to have the things done
* Colleagues proud of my work ← really bad point for me..
* **March 2014**, reality kicks in
* Refuse to accept I wont complete
* But it's the point where I can't do work. Starring at the screen.
* In my mind: Why no one helps me? They are plotting against me?
* **June 2014**: "Tea and chat" appointment on my calendar with a colleague and my boss. 4 hours talking.
emotionally difficult, crying.

First vacation in 5 years!

* One week to finally stop thinking abt work
* Need life outside work
* Family important

It can take months to recover, but it was a start.

Identify areas that are disconnected and how to reconnect Rebuild self-confidence

* Small wins
* Doesn't need to be significant but successful

**Your greatest asset**:

* Help your **TEAM stay sober**
* Encourage **longer vacation**
* help find **tightly scoped** tasks
* **Ask them** for answers they know
* make them **feel wanted**

[↑ Back to the list of talks](#talks)

---

### Adam Surak
_Algolia_

[@adamsurak](https://twitter.com/adamsurak){:target="_blank"}

[slides](https://speakerdeck.com/adamsurak/own-your-reliability-velocity-amsterdam-2016){:target="_blank"}

Algolia: 15 regions (50 physical data centers)

Basic principle, new parallel redundancy:

98% reliable

    --| 99% |---| 99% |--

99.9% reliable

       .- | 99% | -.
    ---             ---
       '- | 99% | -'


SLA (basically up time)

per year

* 99.9% → 43 minutes
* 99.99% → 26s
* 99.9999 % → 2,6s
* 100% → Marketing level

SLA tricks from marketing

* "100% up time, 5% refund every 0.05%" → 99.95%

You need an independent monitoring. It might make sense to make it on your own in certain case (Algolia wanted a 10s freq and that is very expensive with external service so they did it them selves)

Who can safely reboot one **machine** at any time without impacting
customers? a **rack** at any time? a **data center** at any time?

**Underestimated dependencies**

* Two adjacent racks really independent? **most of the time power is not.**
* Protected network? Rooue DHCP? **IP hijack Power**
* Can you choose your rack with your provider? **Yes but mostly need to contact them directly, it is not that easy**
* Pick the physical location of your machines inside a DC. **Algolia actually asks that all the time.**

A/C Power

* influence set of racks Network cables and interfaces **are always broken** 😂
* 1Gbit interface really 1Gbit mode? **Are you checking this?**
* low quality cables

Network maintenance issues

* unplanned
* planned.. but forget to tell you..
* failing

AWS outages

* route leak, broken dynamodb

GCP outages

* sequence of lightning strike: global network issue

Azure has outages too

* global multi-hour outage

Salesforce outages

* EU2 RO, NA14 outage

You name it.. Whatever your provider cloud, self hosted, VMs or bare metal you will have outages or unexpected performance. What can you do about it?

**You can deploy multi-cloud!**

Other outages examples:

* AWS eu-west-1 broke direct connect with OVH
* ISP received 0.0.0.0/0 from a new peer
* Malaysia Telecom annuonced AWS prefixes → US-east-1 unavailable worldwide
* ISP of cloudflare misconfigured router and started to receive all
CloudFare's www traffic in Doha, Qata.

**→ TCP proxy becomes your friend**

DNS.. Default timeouts are usually high in libs

**Have two dns provider as easy as that**

Software design

* TCP checksum not 100% safe
* DNS resolving is not 100% working
* HTTP what is your default timeouts?

Software ops

* package repo gets broken
* invest in introducing failures

Chaos monkey at DNS level: try to iptables reject a small range of ports from DNS.. You might get some people mad with that.

What about your team, the people?

* Who holds knowledge of the system?
* escalate to external provider at some point
* asks people to go to vacation.

[↑ Back to the list of talks](#talks)

---

### Radu and Rafal
_Sematext_

Shard your indices. Day by day is a good example. _(Graylog does it automatically per amount of docs btw)_

Hot/Cold architecture

* Hot IO intensive → prefer SSDs

Keep indices balanced

* `total_shards_per_node`

In AWS

* use different zone allocating
* **Multiple Smaller machines rather than few big machines**

UDP → increase network buffers on destination

ES has built in metrics about time to flush, time to search, time to fetch
indices.. etc.. if you want to tweak your ES cluster you need to monitor these metrics.

[↑ Back to the list of talks](#talks)

---

### George Sudarkoff
_SurveyMonkey_

[@sudarkoff](https://twitter.com/sudarkoff){:target="_blank"}

Distributed Ops analogy with unpredictable military operation.

Give **control to skilled** workers.

**Distribute responsibility** within teams. Give independence (technological, processes) to each team. Anyone should be able to build their service as they want (Go, Python, C, Ruby..)

This is great **but** you need to **standardize** to keep it understandable. And to help knowledge sharing and team mixing.

What to standardize

* rack/instance provisioning
* configuration management
* build
* deployments

Automation?

* E.g. F1 cars. Automation behind the press of a button. But we still need
a skilled pilot.

Automation

* Same thing for ops today in IT.
* A set of things to do gathered into a script. But still need to press a
button to call the script from someone that knows what it will do.

Automation!

* E.g. google car. This is pure automation. No human interactions

Closing

* **Don't be afraid to loose control**
* **SHARE knowledge.**

[↑ Back to the list of talks](#talks)

---

### Björn Rabenstein

_SoundCloud_

[beorn](https://github.com/beorn7){:target="_blank"}

[slides](http://cdn.oreillystatic.com/en/assets/1/event/167/Kubernetes%20and%20Prometheus_%20The%20beginning%20of%20a%20beautiful%20friendship%20Presentation.pdf){:target="_blank"}

Kubernetes + Prometheus = ♥

Both hosted by CNCF Cloud Native Computing Foundation.

Both projects are quite independent.

GIFEE: Google Infra for everybody else.

Google production systems pyramid /\ :

* Product
* Dev
* Capacity Planning
* Testing + Releases
* Postmortem / Root cause analysis
* Incident Response
* Monitoring

**→ Monitoring is important in your infra.**

Monitor all the things

* App     Newrelic, StatsD
* Host    Nagios, Ganglia
* Network Munin, Cactus

Now you add between App and Host

* Container
* Orchestration  Heapster to InfluxDB

**TL;DR to many tools.**

All this replaced by Prometheus with a Grafana UI (and shippers: node
exporter for host, SNMP exporter, cadvisor for containers built-in a kubelet)

Labels from Kubernetes (env, app, zone...) vs classic hierarchy

Service discovery

* DNS SRV
* Consul
* "public" cloud GCP, AWS, AZURE

Prometheus talks to all of them. Poll based system.

Prometheus is pretty opinionated. Tells you quite basic things, histograms,"best practices"

* "four golden signals"
* Brendan Gregg's USE method
* Tom Wilkie's RED method

App rides with Sidecars (ops detail)

* per pods (Kubernetes encapsulated apps) **exporter** + **app** (e.g. mysql
exporter + mysql) plugged directly to Prometheus so it's ready to get logs.

[↑ Back to the list of talks](#talks)


<span class="img-border">
![Walking to catch a bus to RAI conference center](/images/photos/08_nov_amsterdam.jpg)
</span>

## Second day

### Astrid Atkinson
_Google_

> "Come with me if you want to live." Terminator

Are people born for coding? How to make a great team? Can't just try to
find individual rock stars.. **What if greatness was everywhere?**

> "Never doubt that a small group of thoughtful, committed citizens can change the world." Margaret Mead

2004-2012 production team was not that big in google. Engineering team inside ops separated in 3 shards. Very high pressure. Need to observe systems. Listen to suggestions.

Helping to make people amazing and build "rock star" teams

* **Diversity** is **strength**. Not just because they care and have
fairness. → but also brings **Adaptability**. **Spread of talent**. → Effective team. You need complementary people. Planners and doers. Communiquers. Research experts. Women. All skin colors. E.g. in our team we had an ex-firefighter, I'm writer and artist, we had a snowboarder, we had a guy that used to work in a DC swapping HDs. Teams need confidence but needs to be ADAPTABLE too. The later is only achieved with diversity.

* **Inclusive**. See Kate Heddleston's article. The more similar you are
the less you will find different/better ideas, the less other kind of
people will want to join.
E.g. I was the only woman. At some point we had a second woman \o/. She used the word "safe" "it feels safe as you are already here". More woman arrived. Then gay people would be happy to arrive in our team. People felt "welcomed" to come in our team.

* **Understanding**, not just skills. Find people that can grow in anything. Knowing abt existing stuff is not the only thing. **Cognitive bandwidth**. How much expertise can fit in one head. That's difficult you **NEED to spread** the expertise within your team. "Being wrong feels exactly as being right until proven the opposite." Historical loose of expertise (because of high turn over). You need to be aggressive: do a project within the part of the code that is the most scary. You can **TRAIN people**. **Greatness depends on culture**, sharing and opportunity. We learn by doing and we pass it along. E.g. greatest joy of my job was to see people grow to their best opportunity. 50% left to build other great projects, the rest of the people kept maintaining a highly available massive distributed system

* **Give power away**. Give pager/oncall, the key to success with this is
the **feedback loop**. Look what works and what doesn't. Preserve the env. Making the system easier to maintain. In an expanding universe you can make anyone a rock-star.

* Create **safety**. Because you will have failure. It's critical for
innovation. You need to admit you don't know some things. E.g. Best thing
that happen to me: become a senior staff. It's about faith. I want to
build a family, it wasn't going well. But my ex-boss (fav) when I told him
I might want to take time off of the job told me I was the best for the job and that it was my best year opportunity (with promotion). He helped me by having faith in me when I had lost it: it worked really well for me.

* **Values** matters.

* **Mission** matters. What are you doing for the world? Is this the best
use of our talent? **Of course do no harm. But also do good.** "Don't wait for heroes, we are already there"

**TL;DR** Look for people that can challenge you. **Let people speak
up**. If you want an extraordinary team, **be kind**.

[↑ Back to the list of talks](#talks)

---

### Eric McNulty

How to think differently abt leadership. "Artful leadership"

Artful is not about Art - as good as it can be -, it's about

* adaptive capacity
* resilience
* trust.

E.g. The reaction of the people on how the dealt with a horrible event: the Boston 2013 marathon bombing.

* 12 seconds, Time between the two bombs.
* 22 minutes, 254 wounded. Everybody survived. spread across hospitals.

That's abt resilience

* ability to bounce forward
* Understand failure
* from order takers to problem solvers
* 102 Hours, lot's of things happened in Boston. Happened because people
managed to work together.

What went so well? Everything happened 10yrs ago. Preparation, planning - because if close to 9/11. Live exercises where we test people, protocols
and technology. Work with the scenario.

→ Creating high trust env.

**TL;DR** Make a difference in leadership with adaptive capacity,
resilience and trust. People want to stay when they **feel they can make a
difference**. Hope you use your superpower for good.

[↑ Back to the list of talks](#talks)

---

### Phil Stanhope
_Dyn_

A Zombie Apocalypse. Talk ironically presented 5 days before the [Dyn DDoS attack of 21/10/2016](http://dyn.com/blog/dyn-statement-on-10212016-ddos-attack/).

Masked TCP/UDP traffic over the 53 port.

Already 10 yrs ago it was easy to get a server connected to the network and start hacking around. Now with more and more devices it gets even easier.

Scrubbing Tech (cleaning IPs you don't want).
BGP hijack.

IOT →  more problems. E.g. Lightbulbs becoming a router.

Human infection vs Machine infection

* share some basic growth dynamics.
* Infected at a rate base on the disease and population characteristic.

Botnets have a "speed of light" infection rate.
More and more infected hosts. Queue delaying.

How to survive this problem?

OSI layers

* L3: core routers should filter out some of that traffic
* L4:
   * resource exhaustion. TCP handshake, three way acknowledgment sequence.
A send flowed uses this by stopping in the middle ack sequence, with
spoofed IP addresses of course. Attackers of course already have some
"zombie ips" that are already filtered. But you can't filter a complete
ISP.. Stalled machine because of 3.x kernel (machines got all their cores
stalled, running on only one core)
   * Spoofing. Huge address space spoofable. E.g. 191.* totally spoofable.
* L5: session exhaustion. SSL handshake. 20 gbit/secs from 50k concurrent
raspberry pis.
* L7: resource & cache exhaustion. Difficult to separate legitimate / attack traffic. Legitimate retries for example can worsen the case.. on HTTP side of things.

Are we ready for 2 million rq/sec?

Fish in a barrel. (you can shoot them they always come back)
From the **sample** of 3K ips (of 4 million unique A records in dynamic dns
data) **10% of the devices were impacted**. Coming from DVR XiongMai tech cameras. E.g. AvTech IP Cameras.

What to really do?

* **Re-enforce** all the doors and windows
* Have **plans** to identify the infected
  * **Heuristics** for what is requested
  * With a **feedback loop** for signs of infection
* Plans to deal with a herd
  * Router → top rack switch → NIC
  * HTTP(s) endpoints: portal auth, rum beacon submissions, APIs
  * DNS
  * NIC optimally configured. IRQs matter. **Defaults are not the best.**

**TL;DR** Dealing with the incident in real time.

* **Stop** the bleeding
* Establish **incident control**
* **Communication** between teams
* start the **RCA process** (root cause analysis)
* **Status page** outside of your infra
* **Capture** everything

[↑ Back to the list of talks](#talks)

---

### Guy Podjarny
_Snyk.io_

[@guypod](https://twitter.com/guypod){:target="_blank"}

Who owns open source security?

Background of Guy,

* cyber sec part of Israel defense
* CTO Akamai
* CEO & CTO of Snyk

Heartbleed

* Remote mem exposure
* silently and easily exploited
* March 21st found by a guy @Google. Patch their servers.
* Cloudflare alerted abt it and patches their servers.
* 1 April, Google notifies OpenSSL team
* 2nd April, Finnish Codenomicon **independently** discovers the vul
* 3rd April, notifies National Cyber
* 6 April, OpenSSL notifies Red Hat, Facebook patches their servers.

→ "Open source sec done right" corp discovery, corp patches, responsible
disclosure to OSS project.

**However there are still open questions:**

* Who decided who gets early notifications?
* Why not found before? (there since march 2012)
* Steve Marquess (openSSL foundation) has been asked many times.. The pb is they **don't have budget at all**. They have **volunteers**. His answer
is "why it didn't happen more often?"

**Kernel Linux vul** takes **avg of ~5 yrs** to be discovered

Shortly after: ShellShock

* It was there since 1989!
* Fixed and published Sept. 2014

Why Heartbleed is such a big deal? Because **Open Source is everywhere**
(especially openSSL).

Estimate 25% of the (HTTPS) web after heartbleed:

* 2 days later: 11% of top 1M
* 7 days: 5% top of 1M
* 6 weeks: 1.5% still vul

93% patched but only 13% servers swapped cert (/!\ university of Maryland
estimate)
74% of Fortune 2 000 companies didn't patch all servers
Constant stream of active exploits..
A lot of publicity for Heartbleed.

ImageTragick

* Image manipulation lib
* trivially exploited remote command exec

Timeline (2016)

* March 30: vul, CVE issued
* April 30: (partial) fix release
* May 3rd: vul officially published
* More fixes, manual mitigation... shuffling
* June 3: full fix published

**Months without a full fix**! And it's extremely severe vuln..

**Again lots of Open questions**. (Even if it was handled properly tatata
because of the process)

* why first fix incomplete?
* Why so long to fix?
* who should fix this?

**Community** building lib **without even money** (for the case of
imagemagick) why should they fix this?

* Disclosure was done on a medium post, but no one was listening
* So they did a stupid name, stupid logo and a website: imagetragick.com
* It then got all hyped, tweet, HN...

Similar: **Marked**

* npm md parsing package, 2M dw/month
* XSS vul reported (with a fix): May 2015
* Vul fixed (merged): July 2016. 1 year!
* Repo inactive for >1 yr
* Ownership in question
* These people they have a life, their job..

59% of reported vul in maven packages remain unfixed (old stat from ~2yrs
ago). Mean time to fix the 41%: 390 days, CVSS 10 vulns: 265 days

**Hawk**: request validation package (npm). Built within "happy" second most popular JS web framework.

* Vul: ReDos Regular expression denial of service
* Reported & fixed Jan 19, 2016
* Fix quickly \o/
* What's the gotcha?
* only fixed in 4.x which doesn't support older node versions.
* 17M dw/month uses 3.x.. so with the vul (eventually accepted snyk's patch
for 3.x)
* Again it's not that they don't want to fix, it's that they don't have the
BANDWIDTH
* Post of the author "**You're not entitled!**", and yes that's right. He's doing that for free so he has **no obligation to you, to the user.**
* (this is a **case of indirect dependency**) App uses Request, request
uses vul Hawk

**Attackers**

* they **love OSS vuln**
* Panama papers caused because of Drupal
* Verizon: most attacks exploit known vuln that have never been patched
* Symantec estimates that 99% of vuln exploited will continue to be for 1yr

Can develop exploit locally. One vuln, MANY VICTIMS. Human component on top of all that. Often slow to fix & slower to update

TL;DR

* many oss vuln
* take time to find them
* authors usually don't have time to fix
* ...
* **We're doomed?**

→ Well **NO we are not**. BUT it IS a big issue. **As
a community we NEED to help fixing this**

If security matters, don't use open source then?

* NO it is **NOT the answer**.
* OSS because it's fair, because it's what we want for software.

Core challenges then?

* **Incentives**: how to reward OSS devs who get sec right? We should
have something in place for that
* **Ownership**: "everybody's resp is nobody's resp". Where do we draw
the line?
* **Communication**: how to communicate urgent issues to OSS consumers?
In the OSS world, there's a lot of support and privacy guidance and that's good. BUT we need to think abt how to communicate at this. CVE is an example, but it's hard to have one in OSS. (The process is not that simple). Even the feed is hard to handle as a company
* What's our role in this? your role in this?

**Who should help?**

* Authors
* Consumers
* Tooling providers

Org backed vs independent

* Org. Corp (Facebook, Google), Foundation (Apache, Linux, Node), Hybrid
(Mozilla). They get commercial value with this. So it's more in the
commercial side of software.
* Independent
  * **authors**
    * authors can care abt sec. When building OSS try to think abt sec.
    * **TRY** to fix things from the start. Use Brakeman, OWASP ZAP, (snyk.io hm hm),
    * **DECLARE**. E.g security.md file in your repo
    * E.g. Apache Storm focused on sec config
    * E.g. ExpressJS focused on resp disclosure
    * E.g. Apache Aurora. Talks abt known issues
  * **consumers**
    * Not entitled to ANYTHING. not entitled to fix it, **not entitled to
complain**.
    * Use it at your own risk
    * Take action to prevent risk
    * **BEWARE** what OSS you're using. Be aware of dependencies.
    * Address known vuln in OSS components.
    * Think abt vuln binaries (e.g. containers) and packages (npm, gems,
maven..)
    * **REPORT**. responsibly.
    * **CONTRIBUTE**. Linked to report, but proactively, audit, fixes,
comments.

Free for OSS. OSS projects can't pay, so **be kind and help them**

**Github specific wish list**

* private issues & branches
* default/recom security.md
* some form of security +1 (👍 🔓 ?)

Who owns OSS sec? **ALL of us.**

**TL;DR** OSS security is **really hard**. And also really bad because
attackers love it. We as a community need to try to **make it better**. More
process, more awareness, more involvement in sec by everyone.

_Q/A_

Q. How do we as a consumer fix this?

A. no silver bullet. But accept your part of responsibility. There will be
overlap. It's not realistic to complain abt authors for eg. But their role
is more to have a way to more easily share and discuss abt security issues.

[↑ Back to the list of talks](#talks)

---

### Mandi Walls
_Chef_

[@lnxchk](https://twitter.com/lnxchk){:target="_blank"}

Building sec into your workflow w/InSpec

* She's technical community manager for Chef
* mandi@chef.io

Chef

* config management system automation
* EVERY business is a software business
* Work with airlines (in the US) and banks over here (in Europe)

Their products

* workflow: Chef
* Visibility: Habitat
* Compliance: InSpec

How people do **security**? Especially in **nowadays continuous
delivery** platforms?

Mentality of **security reviews as a barrier to production**. "No we
can't do that", "No not this protocol", "Nope"..

→ Chef wants to speed up this process.

We have actually a **communication problem**

* Compliance working with excel docs. Stack of papers.
* Security folks remediation with shell, one liner, grepping..
* Devs "devops" with ruby for example. Infra as code

We wanted this **common language** between these 3 fields being:

* **collaborative**
* **active on the system**. Compliance on a paper is not doing anything
in your system.
* **Speedup** the process

InSpec!

* human readable but machine usable
* create/share profiles. So a compliance officer can publish easily for the
teams to use
* Extensible: being able to build your own ruby class with your rules
* cli tools. Make it easy to be integrated into your workflow, your
"continuous whatever".
*

E.g. ssh

* your security team wants all systems to use SSHv2 to avoid issues in SSHv1

Remediation

* Identify file and file location to check
* figure out sort of incantation
* what's the plan? Rebuild images? Cure at instantiation?
* Likely using a configuration mngmt solution for these types of changes?

Lifecycle

* How often is it checked?
* Yearly or bi-yearly massive scans...

v1.0 of InSpec. Find it at inspec.io, open source, "spec".

Describe a resource. E.g.

~~~ ruby
describe sshd_config do
  impact 1.0

  title "SSH version 2"

  desc <<-TEXT
       blabla compliance text
  TEXT

  its("Protocol") { should cmpl 2 }
end
~~~

* platform agnostic
* abstract the system knowledge

Resources

* Built-in, eg ssh_config, gem, bash, ntp_conf, pip, powershell, npm, yum,
etc files...
* Several linux platforms. And also some windows specific

Run it

* inspec is command line
* can be run locally, test the machine it is executing on
* or remotely, InSpec will log into the target

Test any target. <code>inspec exec test.rb</code>

* locally
* ssh://
* winrm://
* docker://

Failures

* Similar to classic tests, rspec, successful and failures.
* Exit code if failures of course

Test kitchen

* included tester in TK

Profiles

* package of specs to share a set of Inspec tests for your org / app.
* multiple test files, multiples resources
* E.g. middleware profile.
  * java.rb - test versions, locations, included
lib.
  * ports.rb - verify listening ports are correct. services.rb - look for
service accounts, started/stopped, logs etc
* Flexible!
* <code>inspec check myprofile_01/</code>
* <code>inspec exec myprofile_01/</code>
* Chef has a "supermarket" of common profiles

Extending InSpec

* Custom resources. Ruby class inherited `Inpsec.resource` class
* they handle how inspec reads and compiles information. It can be
complicated (matchers and parsers)
* Build for what your need

Over Time (hopefully)

* Build a comprehensive set of checks of your system
* Runs every time someone needs to make some changes
* EASY to use for everyone

We hope people that have the knowledge with compliance can contribute more thanks to that. Faster, more participation and better outcomes.
Approachable by more people.

More infos?

* inspec.io
* github.com/chef-training/workshops
* anniehedgie.com/inspec-basics-l

**TL;DR** Presenting Chef's new tool "InSpec". Trying to fill the gap
between security compliance papers and systems. By defining "specs" on
specific resources of our systems.

Q/A

Q. Where should inspec be used? more in the dev part or infra?

A. We would like people to include this tests whenever they need. E.g. a
normal web app can use profiles that are more app related. Some profiles
are more machine related so can be part of your chef rules. So it's geared
towards infrastructure but it needs to be integrated in the build process.

Q. Does inspec help for external services. Such as AWS LBs for instance?

A. Thinking about it but only on design for now. So for now no.

[↑ Back to the list of talks](#talks)

---

### Cynthia Mai
_Amazon_

dev @ amazon (UI team for amazon.com retail websites)

How we applied best practices and our challenge to implement them.
Usually engineering paradigms that have been proved to be the best way to
do something.

Over 300 million active customers

Distributed development ecosystem - example on a single product page on
amazon → 500+ features

In reality **best practices** are not always best fit for you. You **usually need to adapt/customize**.

1. Preloading
* search result → Product detail.
* 10yrs ago. <iframe>s.
* custom amazon preload js utilty. `preload('http://whateverassets')`
* Buut cross browser compat of course.. Worst case, no css at all. Best
case, no preloading.
* E.g. they had issues with Firefox CORS caching system.
* custom JS utility to common support in browsers. E.g. rel="prefetch".
  → The standard way may not work at huge scale. Their case: 500 features in one page: each one wanting to preloading things...
  → Back to custom solution
1. Responsive. One DOM how does it work at large scale? They had three teams:
* Desktop codebase, webapp codebase and mobile native apps.
* Inconsistent UX
* Long launch times
* duplicate work
* supporting new devices
* long release cycle for mobile. **→ slower innovation**. They moved to one code base, one UX, different layouts. **→  media queries**
* challenges unused bytes down the wire (lots of media queries)
* big maintenance cost
* user experience not as good as expected. Thus they built a custom framework to adapt UX to each device.
  * optimized views per devices
  * shared backend + business logic code
  * CSS + specific device CSSs + segments by browser

    Balance between best practices and resilience. **Iterate to find balance**.

1. Sprites (perf vs perceived perf) - image with all image assets.
* country specific sprites
* E.g. of their Indian sprite without some images
* The got better full page load time BUT the Above the Fold (ATF) didn't
change
* Improvement not visible for the users
* Not worth the extra dev time for this sprites specific.

**TL;DR** Prioritize on providing better perceived perf by following best
practices but tweak on your use case.

[↑ Back to the list of talks](#talks)

---

### Amanda Folson
_Gitlab_

[@ambassadorAwsum](https://twitter.com/ambassadorAwsum){:target="_blank"}

**"On-calliday: Un-sucking your on-call experience"**

* previous pagerduty
* dev/ops land thing

Why **oncall sucks**?

* things in your head but you can't do it because of that oncall pressure
* No sleep
* Too many distractions
* Too little time
* Tethered to your phone/laptop
* Exhaustion

  Especially if you are in a shift where everything is going wrong

**It can be better!**

Intro about burnout, basically what was said by [Avleen Vig](#avleen-vig) yesterday.

* **High stress envs**
* Basic needs not met (sleep or not enough water)
* Caused by emphasis on performance
  * Fear of under-performing
  * not taking vacation

    → oncall burnout

You need **preparation**, **basics** (chargers, cables, small snacks) to **reduce stress**.

Forgetting you're on shift

* it happens
* Relax!

How to **make it easier** from employers?

* Start/end rotations during the day
* NEVER start/end on weekends
* DO NOT start on holiday
* Share the load

Vacation, **track them**.

Select the **right shift length**. Common length: 8, 12, 24 and 1 week

* 8 hours
  * great for day businesses
* 12 hours
  * great for overnight shifts
* 24 hours
  * common
  * relatively low stress when you have a big team
* 1 week
  * most common
  * great for longer period of rest.
  * The bad part is that it's **LONG**.

SO what should I use?

* I prefer to tell everybody to not do 1 week shifts. Apart from if your
**monitoring is mature** enough.

E.g. She likes:

* Mixed Week + Weekends. People oncall for a week have a weekend free and it turns.

**Iterate** on that, **scheduling overrides** has to be done.

Mature monitoring is the key. **Make your data count**! Do postmortems,
notice patterns and **FIX IT** when you find a strange pattern.

**Tooling matters**

Keep staff on their toes.

Incident response. Incident commander see blackrock3.com for details. Note
taking. Record what's going on.

**You write code, your wear it.**

**TL;DR** Oncall sucks. Have an adaptive process that fits with your
monitoring and your team.

Q. Should you give incentive to people on call?

A. Depends of the company, but I believe you should. It's important if your
oncalls miss a diner, family time.. you should give incentives.

Q. How to deal with devs that don't know that much abt ops?

A. I've already seen shadowing for that. (an ops guys shadowing a dev).
DOCUMENTATION is important. Or simply TRAIN.

Q. Docs, postmortems. Do you have recommendation?

A. @gitlab we use Gitlab issues. Some companies use internal wikis. I
personally prefer wikis.

Q. Thoughts on small teams? 1-2 people w/skill and knowledge of oncall

A. Either train someone else. If you can't, take a look at the latest oncall issues and do something abt it. Look at your patterns (hm hm someone said disk space? :D)

[↑ Back to the list of talks](#talks)

---

### Mathias Meyer
_CEO of Travis CI_

[@roidrage](https://twitter.com/roidrage){:target="_blank"}

Used to be dev @Travis, now CEO.

Business rooted in Germany. HQ in Berlin. He now lives there.

Focus in this talk on **culture differences**. They are at the **core**
of what a **distributed team** is. We've noticed big differences between
US and EU.

History of Travis-CI company: distributed build server for the Ruby community. "Bob the builder", bob has a tractor called "Travis". Started at 5. Now we are 40 builders. **Across 9 time zones**.

**Time zones**

Occasionally we experience this: NZST with HAST (23h diff). That's
difficult to handle within a company.

People liked to come to Berlin work with us. But it's not the best thing for our business because we have a large customer base in the US. So we **pushed for remote AND for diversity**.

10 native languages. 16 Home Countries.

> \<include>
>   \<div></div>
> \</include>
> quoting Jan Lehnard

52% remote now. Even if we have an office in Berlin. Not everyone wants to
come in the office.

52% women in engineering. But it doesn't mean the "diversity" label was
achieved. We still want diversity.

Challenges: **COMMUNICATION**

* issue tracking - Github
* async discussions - Slack
* Google docs
* Screen hero
* we do not really use emails. **Very little emails**.
* Slack day to day com, remote stand-ups. **ChatOps** (wonderful buzzword)

Deploy via slack command - so anyone can deploy. `/deploy`

* **increased visibility** in related slack channel.
* removes entrance barriers
* No complex workflow

Infra Heroku based.

Handled in #incident-response slack channel

* **Open**, always sees if there's someone handling an issue
* For bigger outages →  google hangouts.
* We still get phone messages SMS.

We worked our oncall to take timezone into account. They have 12 hours
shifts. All devs are oncall. No real ops team. :clap:

**Blameless culture.**

* **Fair**, just.
* Move away from attributing blame to a specific person. But focused on what **actually happened**.
* It helps faster learning.
* Firing someone, blaming one person, those things will not make your learn anything.

Github all the things.

* **Dev in the open,** lots of code open source. PR, code reviews. Team
work tracked internally.
* Github on-boarding issues. Visibility.

**Everyone does customer support**

* They need to hear and feel customer's frustration
* We want to **break the wall between devs and customers**
* Devs on support rotation. Rotating on the entire engineering team.

**Book allowance**. You can buy any book you like.

Office issues. Someone needs to water the plants.

**Everything in github issues.** It creates **visibility**.

→ ⚠ But it can **make a mess** ⚠

Distributed teams need to **accept** a **TAX on communication**.

* remotely you need to **feel included**. When conversation happens, you
need to document it.
* It's normal to prefer face to face conversation. He personally prefers
writing.

**INCLUSIVE** Communication

* if it's not written down, it doesn't exist.

> "less oral com means more accidental documentation"
>
> Travis CI Team

Can lead to multiple github projects, issues, wikis... We had this pb.
So we started a "Builder"'s **manual**.

Distributed teams need **CENTRALIZED documentation**

YAGR yet another github repo: `how-we-work`

* open salary policy
* code of conduct
* leads to very active conversations
* values

**Inclusive decision making**

* **Give the people** an opportunity to change things
* Give everyone a chance

Doing this inclusive and open discussions it creates a CI for your Company Culture.

E.g. :freedom: (a US flag waving emoji added by me in Slack)

One of the builder turned :freedom: to **a black fist closed**.

We added gender pronoun in profiles.

**Empower everyone**

With time we renamed `#panic` to `#incident-response`.

Scaling distributed culture requires **DOCUMENTATION**. Why a certain thing is there?

Distributed Facetime

* monthly "all hands" (everyone silently wave via hangout)

Friday lightning talks

* Bi weekly things
* **recorded**; So if you can't make it, you can watch it later.

Company hangouts occasionally. **Cultural diversity**.

> "Distributed teams increase the changes of diversity due to having people from diff cultures and backgrounds"
>
> Travis CI team

German, say no. No means no. "That was an 'ok' talk but we need to review 3 things".

US, much more enthusiast abt things. \o/ awesome.

_from US_: great, good, needs improvement

_from German_: great, good, needs improvement, **okay, no**.

**Tone and nuance** gets **lost in writing**

* English main language in the company
* BUT difficult sometimes to parse the nuances, the means.

>"Never attribute to malice or stupidity that which is adequately explained by a missing perspective"
>
> Travis CI Team

**English is ambiguous**

* Lots of meanings for same words in English

It's **ok to ask questions**

* Really, **it's OK to ask questions**
* Even in a distributed fashion, it's ok to ask questions

Work culture

* European benefits to everyone
* 2 **weeks vacations** vs long weekends (in the US)

**Care about the humans.**

> "**Sending people offline for a vacation** is like Chaos Monkey for orgs"
>
> Courtney Nash

Salaries and Cost of Living

* **Salary framework** take that into account
* CTO Konstantin's talk abt that is really nice.
* **Clear expectations abt salary, clear expectations on next steps.**

We are not remote-first.

Team lunch once a week.

Your own Mileage May Very. We do things like that but we have constant
changes.

**Thanking his team. Thanking audience.**
