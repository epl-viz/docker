#!/bin/bash

cd "$(dirname "$0")"

buildAUR() {
  local I DIR
  for I in *.pkg.tar.xz; do
    [ ! -e "$I" ] && continue
    rm $I
  done

  for I in *.tar; do
    [ ! -e "$I" ] && continue
    rm -f $I
  done

  for DIR in *; do
  [ ! -d $DIR ] && continue
    echo "Building (makepkg) $DIR"
    cd $DIR

    for I in *.pkg.tar.xz; do
      [ ! -e "$I" ] && continue
      rm $I
    done

    makepkg -scC
    (( $? == 0 )) && mv *.pkg.tar.xz ..
    cd ..
  done
}

for DIR in *; do
  [ ! -d $DIR ] && continue
  echo "Building $DIR"
  cd $DIR
  buildAUR
  sudo ../mkimage-arch.sh
  cd ..
done
