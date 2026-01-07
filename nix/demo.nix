{
	fetchurl,
	stdenv,
	ffmpeg,
	build-linky,
}:

let
	face = fetchurl {
		url = "https://upload.wikimedia.org/wikipedia/commons/1/1e/Default-avatar.jpg";
		hash = "sha256-IjdE2fII/xlT/iKxtkTy4WJpwHPW0P8nirnO+bulYjk=";
	};
in stdenv.mkDerivation {
	name = "linky-demo";
	
	nativeBuildInputs = [
		build-linky
		ffmpeg
	];
	
	env = {
		LINKY_NAME = "Name";
		LINKY_URL = "https://www.example.com";
		LINKY_INSTAGRAM = "https://www.example.com";
		LINKY_BLUESKY = "https://www.example.com";
		LINKY_TWITTER = "https://www.example.com";
		LINKY_TELEGRAM = "https://www.example.com";
		# https://evanw.github.io/thumbhash/
		LINKY_FACE_THUMBHASH = "Y0YJDwT4N4iMd3eEhcp3eGh4iK9I+IoE";
		LINKY_BANNER_THUMBHASH = "Y0YJDwT4N4iMd3eEhcp3eGh4iK9I+IoE";
	};
	
	unpackPhase = ''
		cp ${face} face.jpg
	'';
	
	buildPhase = ''
		ffmpeg -i face.jpg -vf scale=16:16 icon_16.png
		ffmpeg -i face.jpg -vf scale=32:32 icon_32.png
		ffmpeg -i face.jpg -vf scale=48:48 icon_48.png
		ffmpeg -i face.jpg -vf scale=64:64 icon_64.png
		ffmpeg -i face.jpg -vf scale=96:96 icon_96.png
		ffmpeg -i face.jpg -vf scale=144:144 icon_144.png
		ffmpeg -i face.jpg -vf scale=192:192 icon_192.png
		
		ffmpeg -i face.jpg -vf scale=125:125 face_125.webp
		ffmpeg -i face.jpg -vf scale=250:250 face_250.webp
		ffmpeg -i face.jpg -vf scale=500:500 face_500.webp
		ffmpeg -i face.jpg -vf scale=1000:1000 face_1000.webp
		
		ffmpeg -i face.jpg -vf scale=1000:297 banner.jpg
	'';
	
	installPhase = ''
		export LINKY_ASSETS=$out/assets
		build-linky $out
		mkdir $out/assets
		cp *.png *.jpg *.webp $out/assets/
	'';
}
