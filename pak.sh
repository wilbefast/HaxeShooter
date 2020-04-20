#! /bin/bash

haxe -hl hxd.fmt.pak.Build.hl -lib heaps -main hxd.fmt.pak.Build
hl hxd.fmt.pak.Build.hl
mv -f res.null.pak build/js/res.pak