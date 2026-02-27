return {
  -- File tree
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({})
    end,
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-lua/popup.nvim",
      "AckslD/nvim-neoclip.lua",
      "willthbill/opener.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      require("telescope").setup({})
      require("telescope").load_extension("fzf")
      require("neoclip").setup()
    end,
  },

  -- Harpoon (quick file navigation)
  {
    "ThePrimeagen/harpoon",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      SetupHarpoonKeymaps()
    end,
  },

  -- Comments
  { "scrooloose/nerdcommenter",
    init = function()
      vim.keymap.set("v", "++", "<plug>NERDCommenterToggle")
      vim.keymap.set("n", "++", "<plug>NERDCommenterToggle")
    end,
  },

  -- Auto-close brackets
  {
    "m4xshen/autoclose.nvim",
    config = function()
      require("autoclose").setup()
    end,
  },

  -- Wezterm/tmux pane navigation
  {
    "numToStr/Navigator.nvim",
    config = function()
      require("Navigator").setup()
    end,
  },

  -- Git gutter signs
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- Diagnostics panel
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup()
    end,
  },
}
