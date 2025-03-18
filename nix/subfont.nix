{ buildNpmPackage
, fetchurl
}:

let
	pname = "subfont";
	version = "7.2.1";
	src = fetchurl {
		url = "https://registry.npmjs.org/subfont/-/subfont-${version}.tgz";
		hash = "sha256-8zfMO/3zEKkLI7nZShVpaJxxueM8amdsiIEGmcebLgQ=";
	};
in
buildNpmPackage {
	inherit pname version src;
	
	npmDepsHash = "sha256-vqsm8/1I1HFo9IZdOqGQ/qFEyLTYY5uwtsnp1PJfPIk=";
	
	postPatch = ''
		ln -s ${./subfont-package-lock.json} package-lock.json
	'';
	
	dontNpmBuild = true;
	
	env.PUPPETEER_SKIP_DOWNLOAD = true;
	
	meta = {
		mainProgram = "subfont";
	};
}
