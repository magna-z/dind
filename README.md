dind
====

#### "Docker IN Docker" based on latest "docker:dind" with foreground/background start dockerd.

For start dockerd in background use the system environment "DOCKERD_BACKGROUND=1"!

#### Examples:
**Start dockerd in foreground:**
```
$ docker run --name dind --rm --privileged devinotelecom/dind
Mounting cgroups...
Mounting securityfs...
Starting dockerd...
...

$ docker exec dind docker info
...
```

**Start in background:**
```
$ docker run --rm --privileged -ti --entrypoint sh -e DOCKERD_BACKGROUND=1 devinotelecom/dind

# dockerd-start.sh
Mounting cgroups...
Mounting securityfs...
Starting dockerd in backgroud (log: /var/log/dockerd.log)...

# docker info
...
```
**or:**
```
$ docker run --rm --privileged -ti --entrypoint sh devinotelecom/dind

# DOCKERD_BACKGROUND=1 dockerd-start.sh
Mounting cgroups...
Mounting securityfs...
Starting dockerd in backgroud (log: /var/log/dockerd.log)...

# docker info
...
```

### dockerd [OPTIONS]

dockerd [OPTIONS] maybe used as argumenents.  
Default options: "--host=unix:///var/run/docker.sock --host=tcp://0.0.0.0:2375".

#### Examples:
```
$ docker run --name dind --rm --privileged devinotelecom/dind --version
```
**or:**
```
$ docker run --rm --privileged -ti --entrypoint sh -e DOCKERD_BACKGROUND=1 devinotelecom/dind

# dockerd-start.sh --version
```
