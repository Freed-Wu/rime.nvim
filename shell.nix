{
  pkgs ? import <nixpkgs> { },
}:

with pkgs;
mkShell {
  name = "rime.nvim";
  buildInputs = [
    librime

    pkg-config
    xmake

    (luajit.withPackages (
      p: with p; [
        busted
        ldoc
      ]
    ))
  ];
}
