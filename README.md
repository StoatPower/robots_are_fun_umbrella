# RobotsAreFun.Umbrella

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

### Tasks




### Apps

##### Streamer