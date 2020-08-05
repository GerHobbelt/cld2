#!/bin/sh

set -e

# Parse command line options
while [ $# -gt 0 ]; do
  case "$1" in
    --prefix=*)
      PREFIX="${1#*=}"
      ;;
    *)
      printf "Unknown argument: $1\n"
      printf "Allowed arguments:\n"
      printf "\t--prefix=DIR   install CLD2 to directory DIR\n"
      exit 1
  esac
  shift
done
if [ "x$PREFIX" = "x" ]; then
    PREFIX=/usr/local/cyruslibs
fi
echo "Using $PREFIX as installation directory"

CLD2_INCLUDE_BASE=$PREFIX/include
CLD2_INCLUDE_PATH=$CLD2_INCLUDE_BASE/cld2
CLD2_LIB_PATH=$PREFIX/lib
CLD2_PKGCONFIG_PATH=$CLD2_LIB_PATH/pkgconfig

echo "Installing headers to $CLD2_INCLUDE_PATH"
mkdir -p $CLD2_INCLUDE_PATH/public
mkdir -p $CLD2_INCLUDE_PATH/internal
cp public/*.h $CLD2_INCLUDE_PATH/public
cp internal/integral_types.h internal/lang_script.h internal/generated_language.h internal/generated_ulscript.h $CLD2_INCLUDE_PATH/internal

echo "Installing libraries to $CLD2_LIB_PATH (you probably want to run ldconfig)"
mkdir -p $CLD2_LIB_PATH
cp internal/libcld2_full.so $CLD2_LIB_PATH

echo "Installing pkg-config configuration to $CLD2_PKGCONFIG_PATH"
cat << EOF > cld2.pc
libdir=$CLD2_LIB_PATH
includedir=$CLD2_INCLUDE_PATH

Name: cld2
Description: Compact Language Detector 2
URL: https://github.com/CLD2Owners/cld2
Version: 2
Libs: -L$CLD2_LIB_PATH -lcld2_full
Cflags: -I$CLD2_INCLUDE_BASE
EOF
mkdir -p $CLD2_PKGCONFIG_PATH
cp cld2.pc $CLD2_PKGCONFIG_PATH
