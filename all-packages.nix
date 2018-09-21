with import <nixpkgs> {};
with pkgs.lib;
{
  textfile = callPackage ./textfile.nix {};
}
