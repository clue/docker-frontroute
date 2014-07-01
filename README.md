# docker-frontroute

A docker image to automatically set up a front router (reverse proxy) for linked web containers.

## About FrontRoute

[Docker](https://www.docker.io) is a great tool when it comes to setting up dedicated and isolated environments.
Among others, it can be used to easily start up several web-based containers like your favorite blogging platform,
a wiki and much more.

Once your web-based containers are up, you may want to expose them to the outside world (the internet).
Because each container comes with an own webserver, one has to expose each to a dedicated port (which tend to be *ugly*),
bind to several IPs (which are not always available) or use one of the more complex options (DNS or SSL/SNI-based load balancer) etc.

As an alternative, this docker image allows you to spin up a reverse proxy in front of your existing web containers.
No additional configuration required, besides linking each of your existing web containers to the this container.

## Usage

This docker image is available as a [trusted build on the docker index](https://index.docker.io/u/clue/frontroute/),
so using it is as simple as running:

```bash
$ docker run clue/frontroute
```

Using this image for the first time will start a download automatically.
Further runs will be immediate, as the image will be cached locally.

```bash
$ docker run -d -p 80:80 --link ttrss:ttrss clue/frontroute
```

You can supply any number of linked containers. Each of them has to be given in the format `{ImageName}:{RoutePath}`.

This will start the frontrouter container in a detached session in the background.
This container is disposable, as it doesn't store any sensitive information at all.
If you don't need it anymore, you can `stop` and `remove` it.
