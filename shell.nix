# luarocks --local install rime.nvim-scm-1.rockspec RIME_INCDIR=$(pkg-config --variable=includedir rime) RIME_LIBDIR=$(pkg-config --variable=libdir rime)
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
