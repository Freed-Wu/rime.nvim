{
  pkgs ? import <nixpkgs> { },
}:

with pkgs;
mkShell {
  name = "rime.nvim";
  buildInputs = [
    librime

    stdenv.cc
    pkg-config
    xmake

    (luajit.withPackages (
      p: with p; [
        busted
      ]
    ))
  ];
  # https://github.com/NixOS/nixpkgs/issues/314313#issuecomment-2134252094
  shellHook = ''
    LD="$CC"
  '';
}
