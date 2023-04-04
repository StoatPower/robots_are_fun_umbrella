# RobotsAreFun.Umbrella

## Preamble

This project was completing with Elixir, and though I may be stretching the 
requirement by for the API to be written in "Javascript, Typescript, .NET Core, _or a similar language_", 
I chose to do so for a few reasons:

* **Primarily** - it happens to be the only language I've been working with on a daily basis for 
    the last year and a half, so it's the most reasonable way for me to complete a take-home at
    this point. That said, I have a lot of .NET Core/C# and JS/TS (front-end largely) experience, 
    but it would be a week or two of working with either one to shake off the rust and get back 
    in the groove.
* It has a lot of really nice features that work well for distributed and/or embedded scenarios,
    and it has wonderful ergonomics. I always enjoy showcasing even just a little of that 
    whenever I get the chance. Not trying to change anyones mind, just _expand_ it a little.
* It _is_ similar enough to the others in the sense that it is a general purpose programming language 
    that can do anything the other languages can do and more.

## Disclaimer

I definitely spent more than a couple hours on this project, and that is also for a couple
reasons:

* I don't code in a chill way: not in the sense that I'm raging over my keyboard, but in the
    sense that I have a really hard time doing things half-assed, especially for cool, fun
    problems. It's equal parts fatal-flaw/super-power depending on who you ask. I prefer to
    see it as: I tend to spend more time on something up-front with the expectation that I'll
    have to fix or refactor things less down the road (and I'll hopefully have fewer devs cursing my
    name as they end up with my legacy projects).
* You gave me a cool, fun problem! I can't just do a derp on it and say SHIP IT!  

## Setup (Local)

`Elixir Version 1.14.2`
`Erlang Version 25.1.2`

* [Install elixir](https://elixir-lang.org/install.html) using your preferred method. 
    I'm using an Ubuntu WSL2 on Windows, so I prefer using [asdf](https://asdf-vm.com/guide/getting-started.html),
    which would also works for a variety of other OSes. If using regular Windows, I would suggest using
    [chocolatey](https://community.chocolatey.org/). Both those approaches require grabbing Erlang separately, iirc. 
    Some of your other options like the Windows installer should come pre-bundled with it.
    Docker is also an option but I didn't have time to set it up for this project, apologies.
* Ensure Elixir is installed with `elixir -v`
* [Install Phoenix](https://hexdocs.pm/phoenix/installation.html)
    * `mix local.hex`
    * `mix archive.install hex phx.new`
* Clone the project with `git clone <repo>`.
* Enter project directory `cd /robots_are_fun_umbrella`.
* Fetch dependencies: `mix deps.get`.
* Run tests (only a couple doctests): `mix test`.
* Run the server `mix phx.server`.
* Or interactively with `iex -S mix phx.server` allowing you to use the REPL with the running application.
* Navigate to `http://localhost:5000` if you want to see the nifty auto-generated Phoenix 
* Run the `curl` command to hit the API

```bash
$ curl -X POST http://localhost:5000/api/robots/closest -H "Content-Type: application/json" -d '{"loadId": "4", "x":36, "y":86}'
{"batteryLevel":86,"distanceToGoal":9.85,"robotId":"68"}
```

## Improvements

A handful of improvements immediately come to mind, but the list is by no means exhaustive.
Several are flavored towards what is possible/offered in Elixir, but all improvements are
generalizable to any stack to one degree or another.

#### AI/ML (with Nx, Axon, etc) Instead of Naive Algorithms

A lot of the time I spent on the project was actually revisiting some learning I had done a
couple years ago with genetic algorithms in Elixir. This was before the advent of Elixir Nx and 
the many new related ML/AI libaries popping off in the Elixir ecosystem. So that's one obvious
avenue for improvement. Especially as other factors, rules, and constraints present themselves as
requirements in a real-world situation solving this problem, the naive approach will quickly
lose viability. You can see some of the progress I made towards that end in the branch `genetic_alg`:
it will build but is still a WIP, though I might finish it for fun later this week. To clarify,
I am by no means an ML or Data Science expert, but it's an area I'd be super excited to have a 
professional reason for at least being adjacent to, if not for being directly involved in. 

#### Parallelism & Concurrency

A basic Phoenix app is already very robust out the gate, but manully using OTP constructs like Supervisors,
GenServers, and the like, you could much more realistically and reliably model the distributed state and nature of
many robots being assigned many different tasks.

Likewise, BEAM processes, because they are so lightweight with fully isolated heaps, being scheduled
pre-emptively, could be leveraged to distribute algorithms across CPU cores to run them in parallel (if the
algorithm lends itself to parallel execution, of course). 

That said, each language has it's own mechanisms for supporting concurrency and parallelism,
and digging in to get the best out of your chosen ecosystem can yield several benefits here.

#### Unit Tests

I only added a few doctests to the main API in `robots_are_fun.ex`. Doctests in Elixir are great: they
include documentation on how to use the function with as many example as you want. The examples are
written as if you were writing them in the `iex` repl, and with a single line you can tell your test
suite to execute them as a unit test. They are less used for super comprehensive testing and more as 
smoke-testing the happy path, for didactic reasons, and as a way to ensure that your documentation 
doesn't drift from how your function works as code changes are implemented. Fleshing out the
test suite and adding a code coverage tool like `ex_coveralls` would be highly valuable.

#### More Documentation

Documentation is wonderful and few ecosystems provide as nice a built in way to build enjoyable,
maintainable documentation as Elixir. Each `@moduledoc`, `@typedoc`, or `@doc` is a valid markdown
file that can also execute code (i.e. - doctests). Using the [de-facto approach](https://hexdocs.pm/elixir/writing-documentation.html), 
library and project authors have a standard and highly flexible way of auto-generating aesthetic,
hyper-linked and navigable documentation that can be exported as html, epub, and/or published on a 
public or an organization's private `hex.pm` profile.


## Programming Assignment for SVT Robotics

### Problem Statement

One of SVT's microservices calculates which robot should transport a pallet from point A to point B based on which robot is the closest and has the most battery left if there are multiple in the proximity of the load's location. You'll use a provided API endpoint to create a simplified robot routing API.

This is the endpoint to retrieve a list of robots in our robot [fleet](https://60c8ed887dafc90017ffbd56.mockapi.io/robots). Note: if that URL doesn't work, a mirror is available [here](https://svtrobotics.free.beeceptor.com/robots).

The provided API returns a list of all 100 robots in our fleet. It gives their current position on an xy-plane along with their battery life. Your job is to write an API with an endpoint which accepts a payload with a load which needs to be moved including its identifier and current x,y coordinates and your endpoint should make an HTTP request to the robots endpoint and return which robot is the best to transport the load based on which one is closest the load's location. If there is more than 1 robot within 10 distance units of the load, return the one with the most battery remaining.

The distance between two points is found with the following formula: `sqrt((x2 - x1)^2 + (y2 - y1)^2)`.

### Iteration #1 - Requirements

1. API with POST endpoint that accepts and returns data per the above task description
    * POST endpoint must be https://localhost:5001/api/robots/closest/ or http://localhost:5000/api/robots/closest/
    * POST endpoint must accept and return JSON
1. API can be run locally and tested using Postman or other similar tools
1. Description of what features, functionality, etc. you would add next and how you would implement them - you shouldn't spend more than a few hours on this project, so we want to know what you'd do next (and how you'd do it) if you had more time
1. Use git and GitHub for version control
1. Have fun! We're interested in seeing how you approach the challenge and how you solve problems with code. The goal is for you to be successful, so if you have any questions or something doesn't seem clear don't hesitate to ask. Asking questions and seeking clarification isn't a negative indicator about your skills - it shows you care and that you want to do well. Asking questions is always encouraged at SVT Robotics, and our hiring process is no different.

#### Example JSON Request Payload

```json
{
    loadId: 231, //Arbitrary ID of the load which needs to be moved.
    x: 5, //Current x coordinate of the load which needs to be moved.
    y: 3 //Current y coordinate of the load which needs to be moved.
}
```

#### Example JSON Response Payload

```json
{
    robotId: 58,
    distanceToGoal: 49.9, //Indicates how far the robot is from the load which needs to be moved.
    batteryLevel: 30 //Indicates current battery level of the robot.
}
```

### Deliverables Checklist

1. API written in Javascript, Typescript, .NET Core, or a similar language
1. API accepts POST and returns data per above requirements
1. Repo README has instructions for running and testing the API
1. Repo README has information about what you'd do next, per above requirements
1. Create a new public GitHub repo and upload its url to the link you received in your test invite.