#!/bin/sh

set -e

echo "Cleaning build artefacts"
rm -f public/cld2
ln -s ../internal public/cld2
cd internal
./clean.sh

echo -n "Running build script "
CPPFLAGS="-std=c++98" ./compile_libs.sh
cd ..
rm public/cld2
