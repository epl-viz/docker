#!/bin/bash


cd "$(dirname "$0")"

if (( $# != 1 )); then
  echo "USAGE: $0 <EPL install path>"
  exit
fi

EPL_ROOT="$1"

APPDIR_NAME="EPLViz.AppDir"
COPY_LIB=( "$EPL_ROOT/lib/eplViz" "$EPL_ROOT/lib/wireshark" "/usr/lib/python3.6" )
COPY_BIN=( "$EPL_ROOT/bin/eplviz" "$EPL_ROOT/bin/dumpcap" "/usr/bin/python3.6" "/usr/bin/python3.6m" )
COPY_SHARE=( "$EPL_ROOT/share/eplViz" )
DIRS=( "usr/bin" "usr/lib" "usr/share/icons/hicolor/64x64/apps" )
EXCLUDE_LIBS=( "libGL" "libc.so" "libstdc++" "libgcc_s" "libpthread" "lib/eplViz" )

[ -d "$APPDIR_NAME" ] && rm -rf "$APPDIR_NAME"
mkdir "$APPDIR_NAME"

for i in "${DIRS[@]}"; do
  mkdir -p $APPDIR_NAME/$i
done

cp logo.svg "$APPDIR_NAME/usr/share/icons/hicolor/64x64/apps/eplviz.svg"
cp logo.svg "$APPDIR_NAME/eplviz.svg"
cp eplviz.desktop "$APPDIR_NAME"

gcc -static -o $APPDIR_NAME/AppRun AppRun.c

for i in "${COPY_LIB[@]}"; do
  cp -r "$i" "$APPDIR_NAME/usr/lib"
done

for i in "${COPY_SHARE[@]}"; do
  cp -r "$i" "$APPDIR_NAME/usr/share"
done

LIB_LIST=""

for i in "${COPY_BIN[@]}"; do
  cp "$i" "$APPDIR_NAME/usr/bin"
  LIB_LIST+="$(ldd $i | awk '{print $3}' )"
done

LIB_LIST="$(echo "$LIB_LIST" | sort | uniq )"

for i in "${EXCLUDE_LIBS[@]}"; do
  LIB_LIST="$(echo "$LIB_LIST" | grep -v "$i" )"
done

for i in $LIB_LIST; do
  [ ! -f "$i" ] && continue
  cp "$i" "$APPDIR_NAME/usr/lib"
done

appimagetool "$APPDIR_NAME"
