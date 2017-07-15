# Overview
Parse Reddit's /r/soccer to associate adjectives with soccer teams.
Given an archive of comments, find out what adjectives best describe teams.

# Usage
* Install Ruby.
* Install bundler: http://bundler.io/
* From the root directory, run ``./scripts/run.rb --input-file INPUT-FILE --config-file CONFIG-FILE [--phases PHASES] [--debug]``. The input file must be a .csv with comment body in the first column and comment id in the second.

Example: ``./scripts/run.rb --input-file input/sample.csv --config-file config/teams.yaml``. Note that the output for it is likely to be empty because there are too few adjectives in the sample input, and they are likely to be excluded by the popularity filter.

Real data can be downloaded from https://bigquery.cloud.google.com/dataset/fh-bigquery:reddit_comments

Query tables with ``SELECT body, id FROM <table-name> WHERE subreddit = 'soccer'``.

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

# Results and Publications
[Original post on Reddit](https://www.reddit.com/r/soccer/comments/6mb6le/dominant_bayern_diving_barcelona_the_world/)

[BBC Article](http://www.bbc.co.uk/bbcthree/item/27f450f4-007e-4dff-82dc-604cf03c644e)

[Mirror Article](http://www.mirror.co.uk/sport/football/news/premier-league-three-words-arsenal-10770830)
