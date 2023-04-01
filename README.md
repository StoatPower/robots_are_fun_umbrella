# RobotsAreFun.Umbrella

## Programming Assignment for SVT Robotics

### Iteration #1 - Requirements

1. API with POST endpoint that accepts and returns data per the above task description
    * POST endpoint must be https://localhost:5001/api/robots/closest/ or http://localhost:5000/api/robots/closest/
    * POST endpoint must accept and return JSON
1. API can be run locally and tested using Postman or other similar tools
1. Description of what features, functionality, etc. you would add next and how you would implement them - you shouldn't spend more than a few hours on this project, so we want to know what you'd do next (and how you'd do it) if you had more time
1. Use git and GitHub for version control
1. Have fun! We're interested in seeing how you approach the challenge and how you solve problems with code. The goal is for you to be successful, so if you have any questions or something doesn't seem clear don't hesitate to ask. Asking questions and seeking clarification isn't a negative indicator about your skills - it shows you care and that you want to do well. Asking questions is always encouraged at SVT Robotics, and our hiring process is no different.

### Deliverables Checklist

1. API written in Javascript, Typescript, .NET Core, or a similar language
1. API accepts POST and returns data per above requirements
1. Repo README has instructions for running and testing the API
1. Repo README has information about what you'd do next, per above requirements
1. Create a new public GitHub repo and upload its url to the link you received in your test invite.

### Tasks

1. Fetch list of fake robots from [test url](https://60c8ed887dafc90017ffbd56.mockapi.io/robots) on app start if KV Store is empty or if all robots have zero battery left. If so, init/reset KV Store with these default values.
1. Otherwise, fetch last good state for each robot from KV Store.
1. Assign each robot to a Supervised fleet of RobotServers (GenServers) that act as standins for the true robots and can be communicated with concurrently and independently
1. A RobotServer is either initialized with last good state from KVS or with default state from endpoint


### Apps

##### Streamer