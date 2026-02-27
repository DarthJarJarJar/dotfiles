local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Format on save with formatter.nvim
augroup("FormatAutogroup", { clear = true })
autocmd("BufWritePost", {
  group = "FormatAutogroup",
  pattern = "*",
  command = "FormatWrite",
})

-- Lint on save
autocmd("BufWritePost", {
  pattern = "*",
  callback = function()
    require("lint").try_lint()
  end,
})

-- Close nvim-tree if it's the last window
autocmd("BufEnter", {
  nested = true,
  callback = function()
    if vim.fn.winnr("$") == 1 and vim.fn.bufname() == "NvimTree_" .. vim.fn.tabpagenr() then
      vim.cmd("quit")
    end
  end,
})
