# Docker Sandboxing Tool

Use docker to create a sandbox where all of the OS elements are inside a docker
container but the working directory is on the host.

Useful for experimentation, creating a repeatable development environment, and running code one doesn't fully trust.  

Each sandbox is tied to the current working directory where the 'docksand' command
is run from. The HOME directory inside the container corresponds to the directory from which the 'docksand' command was run.

## Installation

1. Clone this repository
2. link docksand command somewhere in your path

	Example:  ln -s ~/checkouts/docsand/docksand ~/local/bin/docksand

## Usage

1. change into some random directory where you want to keep your experimentation/development files.
2. run `docksand` or `docksand -b repo:tag` or `docksand -c 'commands...'`

Example:
```
$ docksand -c "java:8 ping:ip python:3 node"
Sending build context to Docker daemon  2.048kB
Step 1/2 : FROM ubuntu:latest
 ---> cd6d8154f1e1
Step 2/2 : RUN apt-get update && apt-get install -y openjdk-8-jre-headless iputils-ping python3 nodejs
 ---> Using cache
 ---> c9fa4ef149d0
Successfully built c9fa4ef149d0
Successfully tagged cmdcomp-java8pingippython3node:latest
root@docksand-users-bob-experiment:1548655778:~# java -version
openjdk version "1.8.0_191"
OpenJDK Runtime Environment (build 1.8.0_191-8u191-b12-0ubuntu0.18.04.1-b12)
OpenJDK 64-Bit Server VM (build 25.191-b12, mixed mode)
root@docksand-users-bob-experiment:1548655778:~#
```

NOTE: when specifying `commands` above one can append `:{regex-search}` to specify a package if the command is available in more than one package. Example: `ping:ip` specifies the usage of the `iputils-ping` package.


This will spin up a docker container that will 'wrap around' your current working
directory by mounting it as a volume inside the container.

Feel free to install OS binaries, or play with the 'container OS' in any way you wish.

Changes to the 'container OS' will be preserved.

Exit the shell when you are done playing.

Run 'docksand' command from the same directory to re-enter the same sandbox with
all of your OS changes intact (Note: when you exit the sandbox shell the container
stops as well).

A new image is created each time the docksand command is run based on the previous
container, so there is a running history of each of your 'sandboxing sessions',
should you ever wish to go back to a previous one.
(see `docksand --list` for the full list of containers and images)

If you tire of the sandbox run `docksand --remove` to remove all sandbox images and containers associated with the current directory.

Run 'docksand --help' for full list of everything this baby can do.

NOTE: Running `docksand -b somerepository:sometag` or `docsand -c some-command` will REMOVE all previous sandbox history associated with the current directory.

## TODO

* Easy way to manage and load a previous 'sandboxing session' images

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## Change History

- 2019-Jan-27 : added ability to 'compose commands' via `-c 'cmd1 cmd2 ...'`.


## License

MIT
