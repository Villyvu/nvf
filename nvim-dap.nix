{pkgs, ...}: {
  config.vim.debugger.nvim-dap = {
    enable = true;
    #Keymaps
    mappings = {
      continue = "<leader>ds";
    };
  };
}
