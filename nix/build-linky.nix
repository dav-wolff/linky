{ lib
, writeShellScriptBin
, lightningcss
, subfont
}:

writeShellScriptBin "build-linky" ''
	set -euxo pipefail
	
	rm -rf $1
	mkdir -p $1
	cd $1
	
	sed -e '/<link.*rel="preload".*as="font".*>'/d \
		-e "s|Name|$LINKY_NAME|g" \
		-e "s|#instagram|$LINKY_INSTAGRAM|" \
		-e "s|#bluesky|$LINKY_BLUESKY|" \
		-e "s|#twitter|$LINKY_TWITTER|" \
		-e "s|#telegram|$LINKY_TELEGRAM|" \
		${../index.html} > index.html
	cp --no-preserve=mode ${../font.css} font.css
	cp --no-preserve=mode ${../GolosText.ttf} GolosText.ttf
	${lib.getExe subfont} index.html --font-display block --instance -o subfont
	rm font.css
	
	cp ${../style.css} style.css
	ln -s $LINKY_ICON_16 icon_16.png
	ln -s $LINKY_ICON_32 icon_32.png
	ln -s $LINKY_ICON_48 icon_48.png
	ln -s $LINKY_ICON_64 icon_64.png
	ln -s $LINKY_ICON_96 icon_96.png
	ln -s $LINKY_ICON_144 icon_144.png
	ln -s $LINKY_ICON_192 icon_192.png
	ln -s $LINKY_BANNER_JPG banner.jpg
	ln -s $LINKY_FACE_JPG face.jpg
	ln -s $LINKY_FACE_WEBP face.webp
	
	mv subfont/subfont/fonts-*.css subfont/fonts.css
	mv subfont/subfont/fallback-*.css subfont/fallback.css
	(
		echo '@import "subfont/fonts.css";';
		echo '@import "subfont/fallback.css";';
		echo '@import "subfont/font.css";';
		echo '@import "style.css";'
	) > bundle.css
	${lib.getExe lightningcss} --minify --bundle bundle.css |
		(echo -ne '\t\t<style>\n\t\t\t'; cat -; echo -e '\t\t</style>') |
		sed -i -e '/<link rel="stylesheet" href="\/style.css">/r /dev/stdin' \
			-e '/<link.*rel="stylesheet".*>/d' \
			index.html
	rm bundle.css
	rm -r subfont
	
	echo "Success"
''
