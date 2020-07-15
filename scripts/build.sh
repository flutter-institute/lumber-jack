#!/bin/bash

basedir=`dirname $(dirname $(readlink -f $0))`

cd $basedir
flutter build web && rsync -nav --delete ./build/web ./docs