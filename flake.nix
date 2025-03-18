{
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
		flake-utils.url = "github:numtide/flake-utils";
	};
	
	outputs = { self, nixpkgs, flake-utils, ... }: {
		overlays = {
			subfont = final: prev: {
				subfont = final.callPackage ./nix/subfont.nix {};
			};
			
			linky = final: prev: {
				build-linky = prev.callPackage ./nix/build-linky.nix {};
			};
			
			default = nixpkgs.lib.composeManyExtensions (with self.overlays; [
				subfont
				linky
			]);
		};
	} // flake-utils.lib.eachDefaultSystem (system: let
		pkgs = import nixpkgs {
			inherit system;
			overlays = [
				self.overlays.default
			];
		};
	in {
		packages = {
			inherit (pkgs) subfont build-linky;
		};
		
		apps.default = {
			type = "app";
			program = toString (with pkgs; writeShellScript "serve-linky" ''
				${lib.getExe live-server} --open
			'');
		};
		
		devShells.default = pkgs.mkShell {
			nativeBuildInputs = with pkgs; [
				superhtml
			];
		};
	});
}
