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
}
