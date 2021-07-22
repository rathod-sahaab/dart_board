# dart board

A web server built using [Shelf](https://pub.dev/packages/shelf).

Written in dart and you can throw requests at it, hence, dart board :)

Basic idea is to make a file serving application with features mentioned bellow:

- A folder to serve files from
- Server side generated HTML to provide interface to users
- ReST API to query status of file server(Number of files, disk space occupied by files etc)

## Stack

**Programming:** dart _(frontend and backend)_

**HTML templates:** pug/jade

**Styling:** css

## Development

Make sure you have installed `dart >= 2.12` and `dart2js` they come with `flutter`.

To download packages run

```
pub get
```

To start server in watch mode

```
nodemon
```

This just monitors `bin/` and `lib/` for file changes and re-runs `dart run` (which compiles and runs the app). If you don't have nodemon
just run

If you make changes to `static/*.dart` (which should be compiled to js) make sure to run

```
dart2js -o static/index.dart.js static/index.dart
```

customize above for your file name, I am trying to figure out a way
to do this automatically without re-compiling the whole project.

### Test

Go to [http://localhost:8080](http://localhost:8080) and see changes.

## Details

This serves file from `files-to-server/` directory, which can be customized (not yet);
