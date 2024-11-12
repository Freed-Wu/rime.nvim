{ pkgs ? import <nixpkgs> { } }:

with pkgs;
mkShell {
  name = "rime.nvim";
  buildInputs = [
    pkg-config
    librime
    luajit
    xmake
    stdenv.cc
  ];
  # https://github.com/NixOS/nixpkgs/issues/314313#issuecomment-2134252094
  shellHook = ''
    LD="$CC"
  '';
}
