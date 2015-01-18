#! /bin/bash

git co . &&
git pull -r &&
bundle exec rspec &&
bundle exec cucumber &&
sed -i "s/VERSION.*/VERSION = \"$1\"/g" ./lib/rspec/bisect/version.rb &&
git ci -am "version $1" &&
git tag $1 &&
git push &&
git push $1 &&
rm *.gem &&
gem build rspec-bisect.gemspec
gem push "rspec-bisect-$1.gem"
