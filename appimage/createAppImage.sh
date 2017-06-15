#!/bin/bash


cd "$(dirname "$0")"

if (( $# != 3 )); then
  echo "USAGE: $0 <EPL install path> <python version> <QT plugins root>"
  echo "Usual paths for QT plugins root:"
  echo " - /usr/lib/qt/plugins"
  echo " - /usr/lib/qt5/plugins"
  echo " - /usr/lib/x86_64-linux-gnu/qt5/plugins"
  exit
fi

EPL_ROOT="$1"
PY_VER="$2"
QT_PLUGINS_ROOT="$3"

APPDIR_NAME="EPLViz.AppDir"
COPY_LIB=( "$EPL_ROOT/lib/eplViz" "$EPL_ROOT/lib/wireshark" "/usr/lib/python$PY_VER" )
QT_PLUGINS=( "generic" "platforms" )
COPY_BIN=( "$EPL_ROOT/bin/eplviz" "/usr/bin/python$PY_VER" "/usr/bin/python${PY_VER}m" "$EPL_ROOT/bin/dumpcap" )
COPY_SHARE=( "$EPL_ROOT/share/eplViz" )
DIRS=( "usr/bin" "usr/lib" "usr/share/icons/hicolor/64x64/apps" "usr/lib/qt5" )
EXCLUDE_LIBS=( "libGL" "VBoxOGL" "libEGL.so" "libdl.so" "libm.so" "librt.so" "libresolv.so" "libgcc_s" "libc.so" "libpthread" "lib/eplViz" )
# "libstdc++" "libsystemd.so"


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

for i in "${QT_PLUGINS[@]}"; do
  cp -r "${QT_PLUGINS_ROOT}/$i" "$APPDIR_NAME/usr/lib/qt5/plugins"
  for j in $(find "${QT_PLUGINS_ROOT}/$i" -name "*.so"); do
    LIB_LIST+="$(ldd $j | awk '{print $3}' )"
  done
done

#cp -r "${QT_PLUGINS_ROOT}" "$APPDIR_NAME/usr/lib/qt5"
#for j in $(find "${QT_PLUGINS_ROOT}/" -name "*.so"); do
#  LIB_LIST+="$(ldd $j | awk '{print $3}' )"
#done

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

if [ -x appimagetool-x86_64.AppImage ]; then
  ./appimagetool-x86_64.AppImage "$APPDIR_NAME"
else
  appimagetool "$APPDIR_NAME"
fi
