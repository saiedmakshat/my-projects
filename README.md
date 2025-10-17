Current working app in <h1>Docker-Projects/angular/expense-tracker-main</h1>

<br>

This is working with Jenkins, and all stages are defined in the Jenkins settings.

<br>

for building the app using node 18, not an image but local in the Jenkins server

<br>

for building using nginx: Alpine image means it is a low-size image, about 60M after finishing.

<br>

for testing code using SonarQube in a separate server for buges in code and analysis

<br>

Finally, deploy the app in Docker Swarm from the compose file with limited specs.

<br>

Anything else is for testing and not complete.