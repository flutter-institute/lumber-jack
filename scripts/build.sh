#!/bin/bash

basedir=`dirname $(dirname $(readlink -f $0))`

cd $basedir
flutter build web && cp -R ./build/web/ ./docs