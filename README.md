# Wheelmap.org

Wheelmap.org is an online map to search, find and mark wheelchair-accessible places. Get involved by marking public places like bars, restaurants, cinemas or supermarkets!

## Installation

### Requirements

If you are working on a Mac, please install [Homebrew](http://brew.sh/).

Then install the following required tools:

#### `git`, `wget`

    brew install git wget

#### Latest Ruby 2.1.2 via rbenv

    brew install rbenv ruby-build
    rbenv install 2.1.2
    echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bash_profile
    echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

Restart your shell and install bundler:

    rbenv global 2.1.2
    gem install bundler
    rbenv rehash

### Dependencies

#### MySQL

    brew install mysql
    mkdir -p ~/Library/LaunchAgents
    ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents
    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist

#### ImageMagick

    brew install imagemagick

### Clone the app from Github

    git clone https://github.com/sozialhelden/wheelmap-open-source.git --depth 1
    cd wheelmap-open-source
    bundle install --path vendor/bundle

## Getting started

Copy the example application config:

    cp config/application.yml.sample config/application.yml

Copy the example openstreetmap config

    cp config/open_street_map.SAMPLE.yml config/open_street_map.yml

Copy the example database config and edit accordingly:

    cp config/database.SAMPLE.yml config/database.yml

Edit `database.yml` to reflect your current database settings.

Now lets create the actual database and prepare minimal data:

    bundle exec rake db:create:all db:migrate db:seed

And get some POI data into the database:

    wget http://download.geofabrik.de/europe/germany/berlin-latest.osm.bz2
    bzcat berlin-latest.osm.bz2 | bundle exec rake osm:import

Finally startup a local rails server

    bundle exec rails server

And visit the website in your browser

    http://0.0.0.0:3000/map
