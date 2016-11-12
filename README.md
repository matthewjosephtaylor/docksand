# Docker Sandboxing Tool

Use docker to create a sandbox where all of the OS elements are inside a docker
container but the working directory is on the host.

Useful for experimentation and running code you don't fully trust.  

Each sandbox is tied to the current working directory where the 'docksand' command
is run from.

## Installation

1. Clone this repository
2. link docksand command somewhere in your path

	Example:  ln -s ~/checkouts/docsand/docksand ~/local/bin/docksand

## Usage

1. change into some random directory where you want to keep your experimentation files.
2. run 'docksand' or 'docksand somerepository:sometag'

This will spin up a docker container that will 'wrap around' your current working
directory by mounting it as a volume inside the container.

Feel free to install OS binaries, or play with the container OS in any way you wish.

Changes to the OS will be preserved.

Exit the shell when you are done playing.

Run 'docksand' command from the same directory to re-enter the same sandbox with
all of your OS changes intact (Note: when you exit the sandbox shell the container
stops as well).

A new image is created each time the docksand command is run based on the previous
container, so there is a running history of each of your 'sandboxing sessions',
should you ever wish to go back to a previous one.
(see 'docksand --list' for the full list of containers and images)

If you tire of the sandbox run 'docksand --remove' to remove all images and
containers associated with the sandbox.

Run 'docksand --help' for full list of everything this baby can do.

NOTE: Running docksand somerepository:sometag will REMOVE all previous sandbox
history.

## TODO

* Easy way to manage and load a previous 'sandboxing session' images

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## History

Too early to have a well documented history.
Maybe some day. :)


## License

MIT
