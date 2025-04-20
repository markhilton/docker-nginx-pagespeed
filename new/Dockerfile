#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#
FROM debian:bookworm-slim

LABEL maintainer="NGINX Docker Maintainers <docker-maint@nginx.com>"

ENV NGINX_VERSION=1.27.5
ENV NJS_VERSION=0.8.10
ENV NJS_RELEASE=1~bookworm
ENV PKG_RELEASE=1~bookworm
ENV DYNPKG_RELEASE=1~bookworm

# create nginx user/group first, to be consistent throughout docker variants
RUN groupadd --system --gid 101 nginx \
    && useradd --system --gid nginx --no-create-home --home /nonexistent --comment "nginx user" --shell /bin/false --uid 101 nginx

# Install build dependencies
RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y \
    build-essential \
    ca-certificates \
    curl \
    git \
    libpcre3-dev \
    libssl-dev \
    zlib1g-dev \
    libmaxminddb-dev \
    # Add other dependencies needed by your specific modules if any (e.g., libxml2-dev for xslt, libgd-dev for image_filter)
    && rm -rf /var/lib/apt/lists/*

# Build Nginx from source with custom modules
RUN BUILD_DIR=$(mktemp -d) \
    && cd "$BUILD_DIR" \
    # Clone custom modules (matching the old Dockerfile)
    && git clone https://github.com/vozlt/nginx-module-vts.git \
    && git clone https://github.com/FRiCKLE/ngx_cache_purge.git \
    && git clone https://github.com/simplresty/ngx_devel_kit.git \
    && git clone https://github.com/leev/ngx_http_geoip2_module.git \
    && git clone https://github.com/openresty/echo-nginx-module.git \
    && git clone https://github.com/onnimonni/redis-nginx-module.git \
    && git clone https://github.com/openresty/redis2-nginx-module.git \
    && git clone https://github.com/openresty/srcache-nginx-module.git \
    && git clone https://github.com/openresty/set-misc-nginx-module.git \
    && git clone https://github.com/openresty/headers-more-nginx-module.git \
    && git clone https://github.com/yaoweibin/ngx_http_substitutions_filter_module.git \
    # Download and extract Nginx source
    && curl -fSL "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -o nginx.tar.gz \
    && tar -zxf nginx.tar.gz \
    && cd nginx-${NGINX_VERSION} \
    # Configure Nginx with standard and custom modules
    # Combining flags from old Dockerfile and standard practices
    && ./configure \
        --prefix=/etc/nginx \
        --sbin-path=/usr/sbin/nginx \
        --modules-path=/usr/lib/nginx/modules \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --pid-path=/var/run/nginx.pid \
        --lock-path=/var/run/nginx.lock \
        --http-client-body-temp-path=/var/cache/nginx/client_temp \
        --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
        --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
        --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
        --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
        --user=nginx \
        --group=nginx \
        --with-compat \
        --with-file-aio \
        --with-threads \
        # --with-http_addition_module # (Example standard module, uncomment if needed)
        # --with-http_auth_request_module # (Example standard module, uncomment if needed)
        # --with-http_dav_module # (Example standard module, uncomment if needed)
        # --with-http_flv_module # (Example standard module, uncomment if needed)
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        # --with-http_mp4_module # (Example standard module, uncomment if needed)
        # --with-http_random_index_module # (Example standard module, uncomment if needed)
        --with-http_realip_module \
        --with-http_secure_link_module \
        # --with-http_slice_module # (Example standard module, uncomment if needed)
        --with-http_ssl_module \
        --with-http_stub_status_module \
        --with-http_sub_module \
        --with-http_v2_module \
        # --with-http_v3_module # (Requires specific build setup, uncomment if needed)
        # --with-mail # (Uncomment if needed)
        # --with-mail_ssl_module # (Uncomment if needed)
        --with-stream \
        # --with-stream_realip_module # (Example standard module, uncomment if needed)
        --with-stream_ssl_module \
        # --with-stream_ssl_preread_module # (Example standard module, uncomment if needed)
        # Modules explicitly excluded in the old Dockerfile
        --without-http_autoindex_module \
        --without-http_browser_module \
        --without-http_userid_module \
        --without-mail_pop3_module \
        --without-mail_imap_module \
        --without-mail_smtp_module \
        --without-http_split_clients_module \
        --without-http_uwsgi_module \
        --without-http_scgi_module \
        # --without-http_upstream_ip_hash_module # (Excluded in old Dockerfile, uncomment if needed)
        # Add custom modules from the old Dockerfile
        --add-module="$BUILD_DIR/ngx_devel_kit" \
        --add-module="$BUILD_DIR/ngx_cache_purge" \
        --add-module="$BUILD_DIR/nginx-module-vts" \
        --add-module="$BUILD_DIR/echo-nginx-module" \
        --add-module="$BUILD_DIR/redis-nginx-module" \
        --add-module="$BUILD_DIR/redis2-nginx-module" \
        --add-module="$BUILD_DIR/srcache-nginx-module" \
        --add-module="$BUILD_DIR/set-misc-nginx-module" \
        --add-module="$BUILD_DIR/ngx_http_geoip2_module" \
        --add-module="$BUILD_DIR/headers-more-nginx-module" \
        --add-module="$BUILD_DIR/ngx_http_substitutions_filter_module" \
        # Add standard dynamic modules if needed (requires build dependencies like libxml2-dev, libgd-dev, libgeoip-dev, potentially njs source)
        # --add-dynamic-module=/path/to/njs/module # Example if building njs separately
        # --with-http_xslt_module=dynamic # Requires libxml2-dev, libxslt1-dev
        # --with-http_image_filter_module=dynamic # Requires libgd-dev
        # --with-http_geoip_module=dynamic # Requires libgeoip-dev (Note: different from geoip2 module above)
    && make -j$(getconf _NPROCESSORS_ONLN) \
    && make install \
    # Clean up source and build dependencies
    && apt-get purge -y --auto-remove build-essential git curl \
    && rm -rf "$BUILD_DIR" \
    && rm -rf /var/lib/apt/lists/* \
    # Ensure necessary runtime dependencies are installed (adjust based on actual needs)
    && apt-get update && apt-get install --no-install-recommends --no-install-suggests -y \
        libpcre3 \
        libssl3 \
        zlib1g \
        libmaxminddb0 \
        ca-certificates \
        gettext-base \
        # Add other runtime libs needed by modules (e.g., libxml2, libxslt1.1, libgd3, libgeoip1)
    && rm -rf /var/lib/apt/lists/* \
    # Create cache directories used by default config
    && mkdir -p /var/cache/nginx/client_temp /var/cache/nginx/fastcgi_temp /var/cache/nginx/proxy_temp /var/cache/nginx/scgi_temp /var/cache/nginx/uwsgi_temp \
    && chmod 700 /var/cache/nginx \
    && chown nginx:nginx /var/cache/nginx \
    # Forward request and error logs to docker log collector
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    # Create a docker-entrypoint.d directory
    && mkdir /docker-entrypoint.d
# This section is removed as the build process above handles installation and cleanup.

COPY docker-entrypoint.sh /
COPY 10-listen-on-ipv6-by-default.sh /docker-entrypoint.d
COPY 15-local-resolvers.envsh /docker-entrypoint.d
COPY 20-envsubst-on-templates.sh /docker-entrypoint.d
COPY 30-tune-worker-processes.sh /docker-entrypoint.d
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]
