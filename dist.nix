{pkgs ? import <nixpkgs> {
    inherit system;
  }, system ? builtins.currentSystem, nodejs ? pkgs."nodejs-16_x", ...}:

let
  inherit (pkgs) stdenv lib python2 runCommand writeTextFile writeShellScript;

  nodeDependencies = (pkgs.callPackage ./default.nix {}).nodeDependencies;
in

stdenv.mkDerivation {
  name = "ryujinx-website";
  version = "3.1.0";

  src = ./.;

  buildInputs = [nodejs];
  buildPhase = ''
    ln -s ${nodeDependencies}/lib/node_modules ./node_modules
    export PATH="${nodeDependencies}/bin:$PATH"

    npm run build
  '';
  installPhase = ''
  cp -r dist $out/
  '';
}