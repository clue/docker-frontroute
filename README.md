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
so using this image for the first time will start a download automatically.
Further runs will be immediate, as the image will be cached locally.

As an example, let's assume you own the domain `example.com` and you already have running several docker containers
with their webservers exposed to the outside like this:

```bash
$ docker run -d -p 81:80 --name ttrss clue/ttrss
$ docker run -d -p 82:80 --name h5ai clue/h5ai
```

In this example, you'd have to access your different webservers like this:

```
http://example.com:81/
http://example.com:82/
```

This certainly doesn't have a particularly good usability.
Port numbers are difficult to remember and do not map well to the service actually offered.
Also, available port numbers are a limited resource.

Wouldn't it be nice if we could use clean URLs using sub-paths instead of ports?

```
http://example.com/ttrss/
http://example.com/h5ai/
```

This docker image makes it trivially easy to do so.
Instead of exposing each individual docker image to the outside,
we can use this docker image to place a lightweight and fast reverse proxy (nginx) in front of the other images.

Following the above example, we simple drop the port statements for our webserver instances like this:

```bash
$ docker run -d --name ttrss clue/ttrss
$ docker run -d --name h5ai clue/h5ai
```

Finally, all we have to do is start our new front router container by linking each of the webserver instances like this:

```bash
$ docker run -d -p 80:80 --link ttrss:ttrss --link h5ai:h5ai clue/frontroute
```

This will start the frontrouter container in a detached session in the background.

You can supply any number of linked containers. Each of them has to be given in the format `{ImageName}:{RoutePath}`.

## Ports

For each linked container, it will automatically expose its webserver port through the reverse proxy.
If your container exposes several ports, it will try to use one of the common ports (80, 8080 and 8000) first and
will otherwise fall back to the first available port.

You can also explicitly define a custom port for each webserver by passing an environment variable like this:

```
--env h5ai_port=80
```

## Default route

Now that every sub-route is set up and running, what happens when you access the main (default) URL?

```
http://example.com/
```

Accessing this URL will return a `404 File not found` error.

You can also explicitly define a default route by passing an environment variable like this:

```
--env default=h5ai
```

## Cleanup

This container is disposable, as it doesn't store any information at all.
If you don't need it anymore, you can `stop` and `remove` it.
