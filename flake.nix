{
  description = "Game Night Auto Scheduler";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let 
        pkgs = nixpkgs.legacyPackages.${system};
      in 
      {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "game-night-auto-scheduler";
          version = "0.1.0";
          src = ./.;

          nativeBuildInputs = [ pkgs.babashka ];

          installPhase = ''
            runHook preInstall
            install -Dm755 $src/game-night-scheduler.clj $out/bin/game-night-scheduler
            patchShebangs $out/bin
            runHook postInstall
          '';
        };

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/game-night-scheduler";
        };

        devShells.default = pkgs.mkShell {
          packages = [ pkgs.babashka ];
        };
      });
}
