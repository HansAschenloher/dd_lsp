{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.plugins.lsp.servers.dd_lsp;
in
{

  options.plugins.lsp.servers.dd_lsp = {
    enable = lib.mkEnableOption "the DocDir lsp";
  };

  #config = lib.mkIf cfg.enable {
  config = {
    programs.nixvim.extraConfigLuaPost = ''
      local lspconfig = require('lspconfig')
      local configs = require('lspconfig.configs')

      -- Register the custom LSP server if it's not already defined
      if not configs.dd_lsp then
        configs.dd_lsp = {
          default_config = {
            cmd = { "${pkgs.dd_lsp}/bin/dd_lsp" },
            filetypes = { "*" },  -- Enable for all filetypes
            root_dir = function(fname)
              return lspconfig.util.root_pattern(".git", "dd.config")(fname) or vim.fn.getcwd()
            end,
            settings = {},
          },
        }
      end

      -- Set up the server
      lspconfig.dd_lsp.setup({})
    '';
    programs.nixvim.plugins.lsp.enabledServers = [
      {
        name = "dd_lsp";
        extraOptions = {
          cmd = "${pkgs.hello}/bin/hello";
          autostart = true;
        };
      }
    ];
  };
}
