# Mojolicious Application Scaffold

a Mojolicious web application starter.

## Getting started

Clone repository and install required modules with [Carton](https://metacpan.org/pod/Carton).

```
$ carton install
```

To run application

```
$ carton exec -- morbo script/myapp
```

or run in production mode by adding `MOJO_MODE=production`.

```
MOJO_MODE=production carton exec -- hypnotoad -f script/myapp
```
