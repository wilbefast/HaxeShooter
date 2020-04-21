#! /bin/bash

echo "Building sprite atlas"
cd source_images
../SixPacker/sixpacker.sh foreground
mv -f foreground.png ../res
mv -f foreground.atlas ../res
cd ..

echo "Building Heaps .pak file"
haxe -hl hxd.fmt.pak.Build.hl -lib heaps -main hxd.fmt.pak.Build
hl hxd.fmt.pak.Build.hl

echo "Moving generated .pak to build directory"
mv -f res.null.pak build/js/res.pak

echo "Finishing building .pak file"