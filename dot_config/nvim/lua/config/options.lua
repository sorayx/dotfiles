vim.opt.laststatus = 3
vim.opt.winbar = ""

vim.opt.fillchars = {
  eob = " ",
  horiz = " ",
  horizup = " ",
  horizdown = " ",
  vert = " ",
  vertleft = " ",
  vertright = " ",
  verthoriz = " ",
}

vim.api.nvim_set_hl(0, "WinSeparator", { fg = "NONE", bg = "NONE" })
vim.api.nvim_set_hl(0, "VertSplit", { fg = "NONE", bg = "NONE" })
