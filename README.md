# Docker Nginx + PageSpeed + GEO IP

This docker image based on Debian Stretch linux distribution.
Project goal is an easy to build docker image of latest Nginx web server with Google PageSpeed and Geo IP modules.

## PageSpeed

The [PageSpeed](https://developers.google.com/speed/pagespeed/) tools analyze and optimize your site following web best practices. If turned ON it exposes a PageSpeed admin status page at:

- `http://localhost:8080/pagespeed_admin/`

## VTS

The [VTS](https://github.com/vozlt/nginx-module-vts) Nginx virtual host traffic status module. It exposes a status page at:

- `http://localhost:8080/status/`

## GeoIP

The [GeoIP](https://www.maxmind.com/en/geoip-demo) databases to help decode remote IP address into geographical location.

**Important**: Due to data privacy regulations, [MaxMind made changes](https://dev.maxmind.com/geoip/geoip2/geolite2/) to how you can access free GeoLite2 databases. Since database files cannot be accessed by a public URL, you will have to download them manually.

## More Headers

The [more_set_headers](https://github.com/openresty/headers-more-nginx-module)allows to set more HTTP response headers - useful in multi cluster environments.

## Substitutions Filter

The [subs_filter](https://github.com/yaoweibin/ngx_http_substitutions_filter_module) allows nginx to filter which can do both regular expression and fixed string substitutions on response bodies.

## Json access log

Container will produce web server access log through docker /stdout in json format for easy parsing via 3rd party containers like Fluentd.

### Main features

Include environment variables to turn ON | OFF Page Speed optimization features for:

- images
- javascripts
- style sheets
- cache engine for cluster environments: files, memcached or redis

as well as:

- vhosts stats page
- default host with health check
- [FastCGI file cache](https://www.nginx.com/blog/9-tips-for-improving-wordpress-performance-with-nginx/)
- [Redis memory cache](https://easyengine.io/wordpress-nginx/tutorials/single-site/redis_cache-with-conditional-purging/)

Nginx is configured by default for high performance, multi cluster production environment, but can be easily adjusted with environment variables.

### Configuration

Example docker-compose.yml uses default environment variables:

```env
MAKE_J=4
NGINX_VERSION=1.13.3
PAGESPEED_VERSION=1.12.34.2
LIBPNG_VERSION=1.6.29

### add path to include extra configuration files : (default: off)
NGINX_INCLUDE_PATH=/app/config/nginx/*.conf

### Include default server definition with health check: on|off (default: on)
NGINX_DEFAULT_SERVER=on

### Configure GeoIP support and include extra common fastcgi PHP GeoIP variables: on|off (default: off)
### Deprecated: `NGINX_FASTCGI_GEOIP` variable
NGINX_GEOIP=on

### Google PageSpeed algorithm: on|off (default: off)
NGINX_PAGESPEED=on

### PageSpeed image optimization: on|off (default: off)
NGINX_PAGESPEED_IMG=on

### PageSpeed javascripts optimization: on|off (default: off)
NGINX_PAGESPEED_JS=on

### PageSpeed style sheets optimization: on|off (default: off)
NGINX_PAGESPEED_CSS=on

### PageSpeed cache storage: files|redis|memcached (default: files)
NGINX_PAGESPEED_STORAGE=files

### PageSpeed Redis cache storage address and port: redis.host:port (default: none)
NGINX_PAGESPEED_REDIS=redis.host:6379

### PageSpeed Memcached cache storage address and port: memcached.host:port (default: none)
NGINX_PAGESPEED_MEMCACHED=memcached.host:11211
```

# ARM

Building on Mac M1 ARM https://www.docker.com/blog/multi-arch-images/

```bash
docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t crunchgeek/nginx-pagespeed:1.19.7-r1 .
```
