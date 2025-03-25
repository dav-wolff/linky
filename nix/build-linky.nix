{ writeShellApplication
, gnused
, lightningcss
, subfont
, uglify-js
}:

writeShellApplication {
	name = "build-linky";
	runtimeInputs = [
	gnused
		lightningcss
		subfont
		uglify-js
	];
	
	text = ''
		set -euxo pipefail
		
		rm -rf "$1"
		mkdir -p "$1"
		cd "$1"
		
		sed -e '/<link.*rel="preload".*as="font".*>'/d \
			-e "s|URL|$LINKY_URL|g" \
			-e "s|Name|$LINKY_NAME|g" \
			-e "s|#instagram|$LINKY_INSTAGRAM|" \
			-e "s|#bluesky|$LINKY_BLUESKY|" \
			-e "s|#twitter|$LINKY_TWITTER|" \
			-e "s|#telegram|$LINKY_TELEGRAM|" \
			${../index.html} > index.html
		cp --no-preserve=mode ${../font.css} font.css
		cp --no-preserve=mode ${../GolosText.ttf} GolosText.ttf
		subfont index.html --font-display block --instance -o subfont
		rm font.css
		
		cp --no-preserve=mode ${../style.css} style.css
		ln -s "$LINKY_ICON_16" icon_16.png
		ln -s "$LINKY_ICON_32" icon_32.png
		ln -s "$LINKY_ICON_48" icon_48.png
		ln -s "$LINKY_ICON_64" icon_64.png
		ln -s "$LINKY_ICON_96" icon_96.png
		ln -s "$LINKY_ICON_144" icon_144.png
		ln -s "$LINKY_ICON_192" icon_192.png
		ln -s "$LINKY_BANNER_JPG" banner.jpg
		ln -s "$LINKY_FACE_JPG" face.jpg
		ln -s "$LINKY_FACE_WEBP" face.webp
		
		sed -e "s|LINKY_BANNER_THUMBHASH|$LINKY_BANNER_THUMBHASH|" \
			-e "s|LINKY_FACE_THUMBHASH|$LINKY_FACE_THUMBHASH|" \
			${../thumbhash.js} |
			uglifyjs --compress passes=3,inline=3,toplevel --mangle toplevel -o thumbhash.js
		
		mv subfont/subfont/fonts-*.css subfont/fonts.css
		mv subfont/subfont/fallback-*.css subfont/fallback.css
		(
			echo '@import "subfont/fonts.css";';
			echo '@import "subfont/fallback.css";';
			echo '@import "subfont/font.css";';
			echo '@import "style.css";'
		) > bundle.css
		lightningcss --minify --bundle bundle.css |
			(echo -ne '\t\t<style>\n\t\t\t'; cat -; echo -e '\t\t</style>') |
			sed -i -e '/<link rel="stylesheet" href="\/style.css">/r /dev/stdin' \
				-e '/<link.*rel="stylesheet".*>/d' \
				-e '/<script src="\/thumbhash.js">/r thumbhash.js' \
				-e 's/ src="\/thumbhash.js"//' \
				index.html
		rm bundle.css
		rm style.css
		rm -r subfont
		rm thumbhash.js
		
		echo "Successfully built linky"
	'';
}
