{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.plugins.lsp.servers.dd_lsp;
  inherit (lib) types;
in
{
  options.plugins.lsp.servers.dd_lsp = {
    enable = lib.mkEnableOption "DocDir language Server";

  };

  config = lib.mkIf cfg.enable {
    warnings = lib.nixvim.mkWarnings "plugins.lsp.servers.dd_lsp" {
      when = true;
      message = ''
        dd_lsp, is a very experimental language server and subject to change.
      '';
    };
    plugins.lsp.servers.dd_lsp.package = pkgs.callPackage ./default.nix;
    plugins.lsp.servers.dd_lsp.cmd = "${pkgs.hello}/bin/hello";
  };
}

