# dewey/docker-rutorrent

Docker image based on https://github.com/linuxserver/docker-rutorrent and modified to make a few changes:

- the rTorrent config more suitable for private trackers
- follow my preferences for a folder structure (watch / incomplete / complete)
- move torrents on completion
- only install a small subset of ruTorrent plugins so the web interface gets unusably slow a bit later than usual
- don't compile the `mediainfo` package

## Usage

I use one container for every tracker so for a tracker called `xyz` it would look like that, to prevent port conflicts I just increment the last character of the external port. In that case it's set to `3`.


### Create directory to store volumes

```
mkdir -p /volume1/Archive/rtorrent/rtorrent-xyz /volume1/Archive/rtorrent/rtorrent-xyz/config && \
chown -R dewey:users /volume1/Archive/rtorrent/rtorrent-xyz && \
chmod -R 775 /volume1/Archive/rtorrent/rtorrent-xyz
```

### Create docker container, make sure ports are not conflicting

```
docker create --name=rtorrent-xyz \
-v /volume1/Archive/rtorrent/rtorrent-xyz/config:/config \
-v /volume1/Archive/rtorrent/rtorrent-xyz:/downloads \
-e PGID=100 -e PUID=1026 \
-e TZ=Europe/Berlin \
-p 8003:80 \
-p 5003:5000 \
-p 60003:51413 \
-p 6003:6881/udp \
tehwey/docker-rutorrent
```

Then just start the docker container as usual or, like in my case, through the Synology web interface.

## Parameters

`The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side.
For example with a port -p external:internal - what this shows is the port mapping from internal to external of the container.
So -p 8080:80 would expose port 80 from inside the container to be accessible from the host's IP on port 8080
http://192.168.x.x:8080 would show you what's running INSIDE the container on port 80.`


* `-p 80` - the port(s)
* `-p 5000` - the port(s)
* `-p 51413` - the port(s)
* `-p 6881/udp` - the port(s)
* `-v /config` - where rutorrent should store it's config files
* `-v /downloads` - path to your downloads folder
* `-e PGID` for GroupID - see below for explanation
* `-e PUID` for UserID - see below for explanation
* `-e TZ` for timezone information, eg Europe/London

It is based on alpine linux with s6 overlay, for shell access whilst the container is running do `docker exec -it rutorrent /bin/bash`.

### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" ™.

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## Setting up the application

Webui can be found at `<your-ip>:80` , configuration files for rtorrent are in /config/rtorrent, php in config/php and for the webui in /config/rutorrent/settings.

`Settings, changed by the user through the "Settings" panel in ruTorrent, are valid until rtorrent restart. After which all settings will be set according to the rtorrent config file (/config/rtorrent/rtorrent.rc),this is a limitation of the actual apps themselves.`

** Important note for unraid users or those running services such as a webserver on port 80, change port 80 assignment **

`** It should also be noted that this container when run will create subfolders ,completed, incoming and watched in the /downloads volume.**`

** The Port Assignments and configuration folder structure has been changed from the previous ubuntu based versions of this container and we recommend a clean install **

Umask can be set in the /config/rtorrent/rtorrent.rc file by changing value in `system.umask.set`

## Info

* Shell access whilst the container is running: `docker exec -it rutorrent /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f rutorrent`

* container version number

`docker inspect -f '{{ index .Config.Labels "build_version" }}' rutorrent`

* image version number

`docker inspect -f '{{ index .Config.Labels "build_version" }}' linuxserver/rutorrent`


## Versions

+ **20.11.29:** Remove mediainfo, tweak folder structure, revamp rtorrent config
+ **20.11.16:** Add php7-mbstring package, bump mediainfo to 0.7.90.
+ **14.10.16:** Add version layer information.
+ **04.10.16:** Remove redundant sessions folder.
+ **30.09.16:** Fix umask.
+ **21.09.16:** Bump mediainfo, reorg dockerfile, add full wget package.
+ **09.09.16:** Add layer badges to README.
+ **28.08.16:** Add badges to README, bump mediainfo version to 0.7.87
+ **07.08.16:** Perms fix on nginx tmp folder, also exposed php.ini for editing by user
in /config/php.
+ **26.07.16:** Rebase to alpine.
+ **08.03.16:** Intial Release.
