#!/usr/bin/env tclsh

package require Tcl 8.6

set version 0.0.3

proc must {description commands} {
	try {
		uplevel $commands
	} on error {message} {
		puts stderr "Error: $description failed."
		foreach line [split $message \n] {
			puts stderr "> $line"
		}
		exit 1
	}
}

proc main {origin destination} {
	must "get all branches" {
		set got [exec -ignorestderr git ls-remote --heads $origin]
		set branches [lmap {hash name} $got {
			lindex [split $name /] end
		}]
	}

	must "get main branch" {
		set got [exec -ignorestderr git ls-remote --symref $origin HEAD]
		regexp {refs/heads/(\S+)} $got _ main
	}

	set idx [lsearch $branches $main]
	set branches [lreplace $branches $idx $idx]

	set i 0
	foreach branch $branches {
		puts "$i: $branch"
		incr i
	}

	must "choose branches to setup" {
		if {[llength $branches] > 0} {
			puts -nonewline "Enter the numbers of the branches you want to setup, "
			puts -nonewline "separated by spaces: \n> "
			flush stdout
			set branches [lmap idx [gets stdin] {
				lindex $branches $idx
			}]
		}
	}

	if {![file isdirectory $destination/$main]} {
		must "clone repo" {
			exec -ignorestderr git clone $origin $destination/$main
		}
	}

	cd $destination/$main

	foreach branch $branches {
		if {![file isdirectory ../$branch]} {
			must "setup worktree for branch" {
				exec -ignorestderr git worktree add ../$branch
			}
		}
	}
}

if {[lsearch $argv -h] ne -1 || [lsearch $argv --help] ne -1} {
	puts "clonetrees v$version - a git worktree setup helper"
	puts "\nUsage: clonetrees \[...options\] origin destination"
	puts "\nOptions:"
	puts "  -h, --help        Show this help message"
	puts "\nNote: If no destination is specified, the current directory will be used.\n"
	exit 0
}

switch $argc {
	0 {
		puts stderr "Error: no git origin specified."
		exit 1
	}
	1 {
		set origin [lindex $argv 0]
		set destination [pwd]
	}
	2 {
		set origin [lindex $argv 0]
		set destination [lindex $argv 1]
		file mkdir $destination
	}
	default {
		puts stderr "Error: too many arguments."
		exit 1
	}
}

main $origin $destination
