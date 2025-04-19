{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.plugins.lsp.servers.dd_lsp;
  mkLsp = import ./mklsp.nix;
  inherit (lib) types;
in
{
  imports = [
    (mkLsp {
      name = "dd_lsp";
      package = pkgs.callPackage ./default.nix;
      cmd = "${pkgs.hello}/bin/hello";
    })
  ];
}
