return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "typescript", "go", "python", "swift", "html", "css" },
        auto_install = true,
      })
    end,
  },

  -- Auto-close HTML/JSX tags
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },

  -- LSP
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local lsp_zero = require("lsp-zero")

      lsp_zero.on_attach(function(client, bufnr)
        lsp_zero.default_keymaps({ buffer = bufnr })
        local opts = { buffer = bufnr, remap = false }

        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<A-h>", function() vim.lsp.buf.signature_help() end, opts)
      end)

      lsp_zero.set_sign_icons({
        error = "✘",
        warn = "▲",
        hint = "⚑",
        info = "»",
      })

      require("mason").setup({})
      require("mason-lspconfig").setup({
        handlers = {
          lsp_zero.default_setup,
          lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            require("lspconfig").lua_ls.setup(lua_opts)
          end,
        },
      })

      local cmp = require("cmp")
      local cmp_action = lsp_zero.cmp_action()

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        sources = {
          { name = "path" },
          { name = "nvim_lsp" },
          { name = "luasnip", keyword_length = 2 },
          { name = "buffer", keyword_length = 3 },
        },
        mapping = cmp.mapping.preset.insert({
          ["<Enter>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-f>"] = cmp_action.luasnip_jump_forward(),
          ["<C-b>"] = cmp_action.luasnip_jump_backward(),
        }),
        formatting = lsp_zero.cmp_format(),
      })
    end,
  },

  -- Formatter
  {
    "mhartington/formatter.nvim",
    config = function()
      local function prettier()
        return {
          exe = "prettier",
          args = {
            "--config-precedence", "prefer-file",
            "--print-width", vim.bo.textwidth,
            "--stdin-filepath", vim.fn.shellescape(vim.api.nvim_buf_get_name(0)),
          },
          stdin = true,
        }
      end

      require("formatter").setup({
        filetype = {
          javascript = { prettier },
          typescript = { prettier },
          html = { prettier },
          css = { prettier },
          python = { function() return { exe = "black", args = { "-" }, stdin = true } end },
          go = { function() return { exe = "gofmt", args = {}, stdin = true } end },
          rust = { function() return { exe = "rustfmt", args = { "--emit=stdout" }, stdin = true } end },
          c = { function() return { exe = "clang-format", args = {}, stdin = true } end },
          cpp = { function() return { exe = "clang-format", args = {}, stdin = true } end },
          lua = { function() return { exe = "stylua", args = { "--indent-width", "2", "-" }, stdin = true } end },
        },
      })
    end,
  },

  -- Linter
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("lint").linters_by_ft = {
        markdown = { "vale" },
      }
    end,
  },
}
