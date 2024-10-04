Title: Using Heroku Postgres as a Free Cloud Database Sandbox
Date: 2013-06-16 13:51
Tags: Heroku, Postgres, SQL
Slug: using-heroku-postgres-as-a-free-cloud-database-sandbox

Need a place to experiment with PostgreSQL, but not in the mood to set up the server locally?

Then try out the free dev plan on Heroko Postgres. No configuration or credit card required.

Creating a DB and manipulating it with the psql CLI can be done in just a few steps:

- If you don't already have a favorite postgres client, get the psql command-line program.

If you're using OS X Lion or later, you already have psql; for older OS X installs (or if you want the server binaries too) you can install Postgres via Homebrew with:

```
brew install postgresql
```

For other platforms, <a href="http://www.postgresql.org/download/">download and install the PostgreSQL binaries</a> for your machine.

- Next you'll need a Heroku account - so if you don't already have one, <a href="https://id.heroku.com/signup">sign up</a>.

- Then hit <a href="https://postgres.heroku.com/databases">https://postgres.heroku.com/databases</a>.

- Next, click the "Create Database" button.

If you're shown a pricing page with plans to choose from, first click "Dev Plan (free)", then click "Add Database".

- To get a convenient command you can copy and paste to launch the Postgres CLI on your local machine, click the name of your database, then click the connection settings button.

You should see something along the lines of:

![heroku postgres connection settings]({attach}images/heroku/conn_settings.png)

- In the menu, click PSQL, and a command will appear (already selected!) that you can copy and paste into your terminal to connect the psql command-line program to your database.

- That's it! Assuming psql is in your path, pasting the psql command will put you at an interactive prompt, and you'll be ready to create tables and experiment as you like.

Here's an example session, in which a crude music database is created and queried:

```
$ psql "dbname=YOUR_DB_NAME host=YOUR_EC2_HOST user=YOUR_USER password=YOUR_PASS port=5432 sslmode=require"

=> \d
No relations found.
=>
CREATE TABLE artists (id int, name varchar(80));
CREATE TABLE releases (id int, name varchar(80));
CREATE TABLE recordings (id int, artist_id int, release_id int, name varchar(80));

INSERT INTO artists (id, name) VALUES (1, 'Underworld');
INSERT INTO releases (id, name) VALUES (1, 'Oblivion With Bells');
INSERT INTO recordings (id, artist_id, release_id, name) VALUES (1, 1, 1, 'To Heal');

INSERT INTO artists (id, name) VALUES (2, 'Stars');
INSERT INTO releases (id, name) VALUES (2, 'In Our Bedroom After the War');
INSERT INTO recordings (id, artist_id, release_id, name) VALUES (2, 2, 2, 'The Night Starts Here');

/* Get all recordings of each artist, and show the release */
SELECT rec.name AS recording, a.name AS artist, rel.name AS release
  FROM recordings AS rec
  INNER JOIN artists AS a
    ON rec.artist_id = a.id
  INNER JOIN releases AS rel
    ON rec.release_id = rel.id;

       recording       |   artist   |           release
-----------------------+------------+------------------------------
 To Heal               | Underworld | Oblivion With Bells
 The Night Starts Here | Stars      | In Our Bedroom After the War
(2 rows)
```

