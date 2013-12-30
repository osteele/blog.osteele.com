---
description: A Rake database plugin.
date: '2008-04-17 19:13:36'
layout: post
slug: db-content-rails-plugin
status: publish
title: DB Content Rails Plugin
wordpress_id: '292'
categories: [Libraries, Ruby]
tags: [Ruby, rails, libraries]
---

The DB Content Rails plugin adds tasks to save and restore database content.

<!-- more -->

## Usage

    -- dump the development database to db/archive/development-content.sql.gz
    rake db:content:dump

    -- load the dumped database, and apply any necessary migrations
    $ rake db:content:load

    -- dump the production database to db/archive/production-content.sql.gz
    $ RAILS_ENV=production rake db:content:dump

    -- save the development database to db/archive/{timestamp}.sql.gz
    $ rake db:content:save

    -- save the (compressed) database to my-data.sql.gz
    $ rake db:content:save FILE=my-data.sql.gz

    -- save the (uncompressed) database to my-data.sql
    $ rake db:content:save FILE=my-data.sql

    -- load the database from my-data.sql
    $ rake db:content:load FILE=my-data.sql

## Tasks

    rake db:content:archive

Saves a timestamped database to `db/archive/{timestamp}.sql.gz`.

    rake db:content:dump

Dumps the database to FILE or `db/{RAILS_ENV}-content.sql.gz`.  If FILE ends in `.gz`, the file is compressed.

    rake db:content:load

Loads the database from FILE or `db/{RAILS_ENV}-content.sql.gz`, and migrates it to the current schema version.  If FILE ends in `.gz`, the file is piped through `gunzip`.

## Installation

    git clone git://github.com/osteele/db_content.git vendor/plugins/db_content

If you're running off Edge Rails (or, presumably, Rails > 2.0.2), you should be able to do this instead:

    script/plugin install git://github.com/osteele/db_content

## Limitations

The plugin works only with the MySQL databases. (It adds methods to the Mysql adaptor; see the source.)  The gzip option probably only works on \*nix (MacOS, Linux, etc.).
