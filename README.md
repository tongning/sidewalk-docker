## Project Sidewalk Docker Environment

This repository contains build files that can be used to launch a development environment for Project Sidewalk using [Docker](https://www.docker.com/).

#### Usage instructions

* Follow instructions to [install Docker](https://docs.docker.com/engine/installation/) for your OS.
* Install [docker-compose](https://docs.docker.com/compose/).
* Clone this repository:

  ```bash
  $ git clone https://github.com/tongning/sidewalk-docker.git
  ```
* Obtain a database dump and move it into `docker/postgres`, naming it `sidewalk.sql`:

  ```bash
  $ mv /path/to/databasedump.sql sidewalk-docker/docker/postgres/sidewalk.sql
  ```
* Enter the repository folder and clone the Project Sidewalk platform:

  ```bash
  $ cd sidewalk-docker
  $ git clone https://github.com/ProjectSidewalk/SidewalkWebpage.git
  ```
* Build and run:

  ```bash
  # Run with sudo if necessary
  $ docker-compose up
  ```
  First launch can take a long time for all components to download and build. Once completed, you should see a message like the following:
  ```
  Listening for HTTP on /0:0:0:0:0:0:0:0%0:9000
  ```
  Once you see this message, visit `http://localhost:9000` to see the webpage.
  
  <font color="#FF5544">Note:</font>
  
  You may encounter errors related to failed downloads of Scala components. To resolve them, just quit (Ctrl+C) and rerun `docker-compose up` until all components download successfully. This is a [known issue](https://github.com/ProjectSidewalk/SidewalkWebpage/issues/483).
 * You are finished! Edit the code in the SidewalkWebpage folder, and  the site will rebuild automatically. You can also connect a debugger to port 9999 on your local machine. We recommend using an IDE, such as IntelliJ.
  
#### Configuration notes

The `docker-compose.yml` file sets up three linked Docker containers - `postgres`, `web`, and `grunt`.
* `postgres` hosts the sites PostgreSQL database, which stores users data, labels, and other information. If you need to view or modify database entries directly, you can do so by connecting a Postgres client (e.g. [pgAdmin](https://www.pgadmin.org/)) to port 5432 on your host machine.
* `web` runs the Scala web application using [Activator](https://www.lightbend.com/activator/download).
* `grunt` runs the nodejs "grunt" module on the source files. It watches for changes in Javascript files and copies Javascript code to the correct locations.

  
  
