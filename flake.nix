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
            }: let
            in {
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

                git.enable = true;

                fzf-lua = {
                  enable = true;
                  profile = "telescope";
                };

                extraPackages = with pkgs; [
                  netcoredbg
                  csharpier
                  libxml2
                  astyle
                  clojure
                ];
                lazy = {
                  plugins = {
                    "easy-dotnet.nvim" = {
                      package = pkgs.vimPlugins.easy-dotnet-nvim;
                      setupModule = "easy-dotnet";
                      setupOpts = {
                        debugger = {
                          bin_path = "${pkgs.netcoredbg}/bin/netcoredbg";
                          auto_register_dap = true;
                        };
                      };
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

                notes.neorg = {
                  enable = true;
                  treesitter.enable = true;
                  setupOpts = {
                    "core.default" = {
                      enable = true;
                    };
                    load = {
                      "core.concealer" = {};
                      "core.dirman" = {
                        config = {
                          workspaces = {
                            notes = "~/notes";
                            fs = "~/fs";
                          };
                        };
                      };
                    };
                  };
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
                  setupOpts = {
                    defaults = {
                      # Drop nvf's default --no-ignore so ripgrep honors .gitignore
                      # (excludes node_modules/, bin/, obj/, target/, .cpcache/, .git/
                      # at the source instead of post-filtering every match in Lua).
                      # Keep --hidden so dotfiles like .github/ stay searchable; rg
                      # still skips .git/ via the glob below.
                      vimgrep_arguments = [
                        "${pkgs.ripgrep}/bin/rg"
                        "--color=never"
                        "--no-heading"
                        "--with-filename"
                        "--line-number"
                        "--column"
                        "--smart-case"
                        "--hidden"
                        "--glob=!**/.git/*"
                      ];
                      # Defense-in-depth for build/cache dirs (Lua patterns).
                      file_ignore_patterns = [
                        "node_modules"
                        "%.git/"
                        "dist/"
                        "build/"
                        "target/"
                        "result/"
                        "bin/"
                        "obj/"
                        "%.cpcache/"
                      ];
                    };
                  };
                  # Native (compiled-C) sorter; nvf auto-loads it via load_extension.
                  extensions = [
                    {
                      name = "fzf";
                      packages = [pkgs.vimPlugins.telescope-fzf-native-nvim];
                      setup.fzf = {
                        fuzzy = true;
                        override_generic_sorter = true;
                        override_file_sorter = true;
                        case_mode = "smart_case";
                      };
                    }
                  ];
                };
                telescope.enable = true;
                utility.icon-picker.enable = true;
                treesitter = {
                  enable = true;
                  indent.enable = false;
                };

                autocomplete.blink-cmp = {
                  enable = true;
                  setupOpts = {
                    keymap = {
                      preset = "enter";
                    };
                    signature = {
                      enabled = true;
                    };
                    sources = {
                      default = ["lsp" "easy-dotnet" "path"];
                      providers = {
                        "easy-dotnet" = {
                          name = "easy-dotnet";
                          enabled = true;
                          module = "easy-dotnet.completion.blink";
                          score_offset = 10000;
                          async = true;
                        };
                      };
                    };
                  };
                };

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
                    default_format_opts = {
                      async = true;
                      timeout_ms = 5000;
                    };
                    command = "ConformInfo";
                    formatters_by_ft = {
                      cs = ["astyle"];
                      xml = ["xmllint"];
                    };
                    # format_on_save = {
                    #   timeout_ms = 500;
                    #   lsp_fallback = true;
                    # };
                  };
                };

                filetree.nvimTree = {
                  enable = true;
                  setupOpts = {
                    disable_netrw = true;
                    actions.open_file.eject = true;
                    renderer = {
                      indent_markers.enable = true;
                      icons.glyphs.folder = {
                        arrow_closed = "";
                        arrow_open = "";
                      };
                    };
                    view = {
                      width = {
                        min = 30;
                        max = -1;
                        padding = 1;
                      };
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
                # Show the (relative) path to the file, not just the filename.
                # path = 1 -> relative to cwd (use 2 for absolute, 3 for ~/absolute).
                # statusline.lualine.activeSection.b = [
                #   ''
                #     {
                #       "filetype",
                #       colored = true,
                #       icon_only = true,
                #       icon = { align = 'left' }
                #     }
                #   ''
                #   ''
                #     {
                #       "filename",
                #       path = 1,
                #       symbols = {modified = ' ', readonly = ' '},
                #       separator = {right = ''}
                #     }
                #   ''
                #   ''
                #     {
                #       "",
                #       draw_empty = true,
                #       separator = { left = '', right = '' }
                #     }
                #   ''
                # ];
                statusline.lualine.inactiveSection.c = [
                  "{'filename', path = 1}"
                ];
                visuals.nvim-web-devicons.enable = true;
                visuals.indent-blankline.enable = true;

                undoFile.enable = true;

                #Vim options
                options = {
                  signcolumn = "yes";
                  updatetime = 250;
                  splitright = true;
                  scrolloff = 10;
                  ignorecase = true;
                  smartcase = true;
                  timeoutlen = 300;
                  list = true;
                  confirm = true;
                  breakindent = true;
                };

                # lsp = {
                #   formatOnSave = true;
                #   servers = {
                #     lemminx = {
                #     cmd = ()
                #   };
                # };

                repl.conjure.enable = true;
                languages = {
                  nix = {
                    enable = true;
                    lsp.enable = true;
                    format.enable = true;
                    treesitter.enable = true;
                  };
                  csharp = {
                    enable = true;
                    lsp.enable = false;
                    treesitter.enable = true;
                  };
                  clojure = {
                    enable = true;
                    lsp.enable = true;
                    treesitter.enable = true;
                  };
                  typescript = {
                    enable = true;
                    lsp.enable = true;
                    treesitter.enable = true;
                  };
                };

                assistant.codecompanion-nvim = {
                  enable = true;
                  setupOpts = {
                    strategies = {
                      chat = { adapter = "claude_code"; };
                      inline = { adapter = "claude_code"; };
                      agent = { adapter = "claude_code"; };
                    };
                  };
                };
              };
            })
            ./keymaps.nix
            ./nvim-dap.nix
          ];
        })
        .neovim;
    };
  };
}
