#!/bin/bash

basedir=`dirname $(dirname $(readlink -f $0))`

cd $basedir
flutter build web && rsync -av --delete ./build/web/* ./docs