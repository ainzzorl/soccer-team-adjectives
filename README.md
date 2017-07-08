# Overview
Parse Reddit's /r/soccer to associate adjectives with soccer teams.
Given an archive of comments, find out what adjectives best describe teams.

# Usage
* Install Ruby.
* Install bundler: http://bundler.io/
* From the root directory, run ``./scripts/run.rb <path-to-input>``. The input file must be a .csv with comment body in the first column and comment id in the second.

# Algorithm
## Phase 1
Count team name/adjective pairs used in the same sentence.

## Phase 2
* Filter out blacklisted adjectives (nationalities, colors, ...).
* Exclude N most popular adjectives: they are too generic.
* Score adjectives. Promote somewhat unusual words.
* Keep only M adjectives per team.

# Phase 3
Export results to .csv files per league.
