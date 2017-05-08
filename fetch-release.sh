#!/bin/bash

U=tbrowder

if [[ -z $1 ]] ; then
    echo "Usage: $0 <version>"
    echo
    echo "Fetches the Foo::Bar release for version $1"
    echo "  for gituser $U."
    exit
fi

wget https://github.com/$U/archive/$1.zip

