#!/usr/bin/env ruby

`cat ./tmp/phase1/reduced.json |
    bundle exec ruby ./scripts/phase2/filter-blacklisted-adjectives.rb |
    bundle exec ruby ./scripts/phase2/filter-common-adjectives.rb |
    bundle exec ruby ./scripts/phase2/score.rb |
    bundle exec ruby ./scripts/phase2/sort.rb |
    bundle exec ruby ./scripts/phase2/take-top.rb > tmp/phase2/result.dat`
