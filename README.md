`docker pull jaydp123/jubuntu:latest`

# How to run:

## Helpful Commands: 

### Run a new container (options explained below):
`docker run -it --name jubuntu -p 3001:3000 -v /Users/jaydp123/projects:/home -v ssh_jub:/root/.ssh`

### Connect to CL from a stopped container
`docker start jubuntu`
`docker attach jubuntu`

### Options explained

#### Exposing ports:

Be careful not to conflict with any other containers, for Rails: I use 3001 to avoid conflicting with other Rails containers I have running. Generally I would dockerify an app I'm working on with docker-compose and run it seperately, I would not run it in jubuntu. Anyway:

`-p 3001:3000`

#### Mount your development directory:

My local development directory is /Users/jaydp123/projects:

`-v /Users/jaydp123/projects:/home`

#### Mount an ssh volume:

The first time you run the container this will be empty, run `ssh-keygen`, then this volume will persist and ssh-keys will be loaded for future runs of jubuntu (or any other container that wants to use the keys):

`-v ssh_jub:/root/.ssh`

## Thoughts/Recommendations?

Please add an issue to the Github repo. 

Happy coding!