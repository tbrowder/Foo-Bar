[![Actions Status](https://github.com/tbrowder/Foo-Bar/actions/workflows/linux.yml/badge.svg)](https://github.com/tbrowder/Foo-Bar/actions) [![Actions Status](https://github.com/tbrowder/Foo-Bar/actions/workflows/macos.yml/badge.svg)](https://github.com/tbrowder/Foo-Bar/actions) [![Actions Status](https://github.com/tbrowder/Foo-Bar/actions/workflows/windows.yml/badge.svg)](https://github.com/tbrowder/Foo-Bar/actions)

NAME
====

**Foo::Bar** is a dummy module illustrating showing and downloading /resources files

SYNOPSIS
========

Show file paths under /resources

```raku
$ foo-bar s
OUTPUT:
...
```

Download files into the current directory:

```raku
$ foo-bar d
OUTPUT:
Downloading /resources files to directory
  /usr/local/git-repos/my-public-modules/Foo-Bar:
    File 'more.txt' exists, skipping...
    File 'some.txt' exists, skipping...
```

DESCRIPTION
===========

**Foo::Bar** is a test module with one file in the /resources directory, but no corresponding entry in the META6.json file.

AUTHOR
======

Tom Browder <tbrowder@acm.org>

COPYRIGHT AND LICENSE
=====================

© 2024 Tom Browder

This library is free software; you may redistribute it or modify it under the Artistic License 2.0.

