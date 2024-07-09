{ pkgs ? import <nixpkgs> { } }:

with pkgs;
mkShell {
  name = "rime.nvim";
  buildInputs = [
    rime.dev
  ];
}
