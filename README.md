# clonetrees 🌲🌲🌲
![Semver badge](https://flat.badgen.net/badge/semantic%20versioning/2.0.0/blue)
![CC badge](https://flat.badgen.net/badge/conventional%20commits/1.0.0/blue)

A helper script to clone git repositories for a worktree-centric workflow.

# Usage

Just call the script and give a git origin URL and optionally local path.

```bash
$ clonetrees --help
clonetrees v0.0.1 - a git worktree setup helper

Usage: clonetrees [...options] origin destination

Options:
  -h, --help        Show this help message

Note: If no destination is specified, the current directory will be used.

$ clonetrees git@example.com:nobody/example.git local-example             
0: branch-a
1: branch-b
Enter the numbers of the branches you want to setup, separated by spaces: 
> 1
Cloning into 'local-example/main'...
done.
Preparing worktree (new branch 'branch-b')
$ ls local-example
branch-b  main
```

# Installation

Requires git version 2.42 and Tcl version 8.6 or later.

Just download the script and mark it executable.
Or, use [the Nix package].

[the Nix package]: https://github.com/nat-418/grimoire

