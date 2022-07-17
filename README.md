# Steelman Anything

## Introduction

This is the source of the Steelman Anything website at <https://steelmananything.com/>. The main topics are in the [_topics](_topics) folder.

We welcome contributions but please first review the [contribution guidelines](CONTRIBUTING.md).

## License

All content is licensed in the public domain with the [CC0 license](LICENSE.txt): To the extent possible under law, the contributors to Steelman Anything have waived all copyright and related or neighboring rights to this content. This work is published from the United States.

## Development

### Pre-requisites

1. Install [Ruby](https://www.ruby-lang.org/)
2. `gem install bundler jekyll`
3. `git clone https://github.com/steelmananything/steelmananything`
4. `cd steelmananything`
5. `bundle install`

### Running

1. `bundle exec jekyll serve --livereload`
2. Open <http://localhost:4000/>

### Deploying

1. `bundle exec jekyll build`
2. `rsync -rlpt --progress --delete _site/* $SERVER:$DIRECTORY`

### Copying to Substack

1. If copying from a blog post that primarily references a topic page, add the query `?nopermalinks=true&anchorroot=/topics/.../`
2. Otherwise, just add `?nopermalinks=true`

### Nginx configuration

```
server {
  listen 80 default_server;
  listen [::]:80 default_server;
  server_name _;
  return 301 https://$host$request_uri;
}

server {
  server_name _;
  listen       443 ssl http2 default_server;
  listen       [::]:443 ssl http2 default_server;
  root $DIRECTORY;
  index index.html;
  add_header 'Cache-Control' "no-cache";
  ssl_certificate "/etc/letsencrypt/live/$HOST/fullchain.pem";
  ssl_certificate_key "/etc/letsencrypt/live/$HOST/privkey.pem";
  ssl_session_cache shared:SSL:1m;
  ssl_session_timeout  10m;
  ssl_ciphers PROFILE=SYSTEM;
  ssl_prefer_server_ciphers on;
}
```
