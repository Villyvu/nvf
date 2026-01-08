{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
  };
  outputs = {nixpkgs, ...} @ inputs: {
    packages.x86_64-linux = {
      # Set the default package to the wrapped instance of Neovim.
      # This will allow running your Neovim configuration with
      # `nix run` and in addition; sharing your configuration with
      # other users in case your repository is public.
      default =
        (inputs.nvf.lib.neovimConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            ({
              pkgs,
              lib,
              ...
            }: {
              config.vim = {
                augroups = [
                  {
                    name = "highlight-yank";
                    clear = true;
                  }
                ];
                autocmds = [
                  {
                    event = ["TextYankPost"];
                    enable = true;
                    group = "highlight-yank";
                    callback = lib.generators.mkLuaInline ''                      function()
                         vim.highlight.on_yank()
                       end'';
                  }
                ];

                fzf-lua = {
                  enable = true;
                  profile = "telescope";
                };

                lazy = {
                  plugins = {
                    "easy-dotnet.nvim" = {
                      package = pkgs.vimPlugins.easy-dotnet-nvim;
                      setupModule = "easy-dotnet";
                      ft = "cs";
                    };
                  };
                };

                globals = {
                  maplocalleader = " ";
                  mapleader = " ";
                };
                theme = {
                  enable = true;
                  name = "onedark";
                };

                telescope = {
                  mappings = {
                    findFiles = "<leader>sf";
                    liveGrep = "<leader>sg";
                    buffers = "<leader><leader>";
                    helpTags = "<leader>sh";
                    diagnostics = "<leader>sd";
                    resume = "<leader>sr";
                  };
                };
                telescope.enable = true;
                utility.icon-picker.enable = true;
                treesitter.enable = true;

                autocomplete.blink-cmp.enable = true;

                binds = {
                  whichKey.enable = true;
                };

                clipboard = {
                  enable = true;
                  registers = "unnamedplus";
                  providers.xclip.enable = true;
                };

                mini.ai.enable = true;
                mini.surround.enable = true;

                autopairs.nvim-autopairs.enable = true;

                formatter.conform-nvim = {
                  enable = true;
                  setupOpts = {
                    command = "ConformInfo";
                    format_on_save = {
                      timeout_ms = 500;
                      lsp_fallback = true;
                    };
                  };
                };

                filetree.nvimTree = {
                  enable = true;
                  setupOpts = {
                    renderer = {
                      indent_markers.enable = true;
                      icons.glyphs.folder = {
                        arrow_closed = "";
                        arrow_open = "";
                      };
                    };
                    view = {
                      relativenumber = true;
                    };
                  };
                  #Mappings
                  mappings = {
                    toggle = "<leader><Tab>";
                  };
                };

                statusline.lualine.enable = true;
                statusline.lualine.icons.enable = true;
                visuals.nvim-web-devicons.enable = true;
                visuals.indent-blankline.enable = true;

                undoFile.enable = true;

                #Vim options
                options = {
                  breakindent = true;
                  signcolumn = "yes";
                  updatetime = 250;
                  splitright = true;
                  scrolloff = 10;
                  ignorecase = true;
                  smartcase = true;
                  timeoutlen = 300;
                  list = true;
                  confirm = true;
                };

                lsp.formatOnSave = true;
                languages = {
                  nix = {
                    enable = true;
                    lsp.enable = true;
                    format.enable = true;
                  };
                  csharp = {
                    enable = true;
                  };
                };
              };
            })
            ./keymaps.nix
          ];
        })
        .neovim;
    };
  };
}
