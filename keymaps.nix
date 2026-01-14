{...}: let
  nmap = {
    key,
    action,
    desc ? null,
    silent ? true,
    lua ? false,
  }: {
    mode = "n";
    inherit key action desc silent lua;
  };

  dotnet = {
    key,
    action,
    desc,
    lua ? false,
  }: {
    mode = "n";
    silent = true;
    inherit key action desc;
  };
in {
  config.vim.keymaps = [
    (nmap {
      key = "<leader>q";
      action = "<cmd>lua vim.diagnostic.setloclist()<cr>";
      desc = "Open diagnostic location list";
    })

    (nmap {
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
      desc = "Clear search highlight";
    })

    (nmap {
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
      desc = "Clear search highlight";
    })

    (nmap {
      key = "<C-h>";
      action = "<C-w><C-h>";
      desc = "Move focus to the left window";
    })

    (nmap {
      key = "<C-l>";
      action = "<C-w><C-l>";
      desc = "Move focus to the right window";
    })

    (nmap {
      key = "<C-j>";
      action = "<C-w><C-j>";
      desc = "Move focus to the lower window";
    })

    (nmap {
      key = "<C-k>";
      action = "<C-w><C-k>";
      desc = "Move focus to the upper window";
    })
    # Telescope extras (not NVF-wrapped)
    (nmap {
      key = "<leader>sk";
      action = "<cmd>Telescope keymaps<CR>";
      desc = "[S]earch [K]eymaps";
    })
    (nmap {
      key = "<leader>sw";
      action = "<cmd>Telescope grep_string<CR>";
      desc = "[S]earch current [W]ord";
    })
    (nmap {
      key = "<leader>ss";
      action = "<cmd>Telescope builtin<CR>";
      desc = "[S]earch [S]elect Telescope";
    })
    (nmap {
      key = "<leader>s.";
      action = "<cmd>Telescope oldfiles<CR>";
      desc = "[S]earch Recent Files (\".\" for repeat)";
    })
    (nmap {
      key = "grr";
      action = ''require('telescope.builtin').lsp_references'';
      desc = "Go to implementation";
      lua = true;
    })

    # Dotnet Keymaps
    (dotnet {
      key = "<leader>dts";
      action = "<cmd>Dotnet testrunner<CR>";
      desc = "Start testrunner";
    })
    (dotnet {
      key = "<leader>dtb";
      action = "<cmd>Dotnet testrunner refresh build<CR>";
      desc = "Start testrunner";
    })
    (dotnet {
      key = "<leader>dwr";
      action = "<cmd>Dotnet watch<CR>";
      desc = "Watch project";
    })
  ];
}
