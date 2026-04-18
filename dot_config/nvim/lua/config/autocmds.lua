local function transparent()
  local groups = {
    -- generisch
    "Normal",
    "NormalNC",
    "SignColumn",
    "EndOfBuffer",
    "LineNr",
    "FoldColumn",
    "NormalFloat",
    "FloatBorder",
    "FloatTitle",
    "WinSeparator",
    "WinBar",
    "WinBarNC",
    "StatusLine",
    "StatusLineNC",
    "MsgArea",
    "MsgSeparator",

    -- noice
    "NoicePopup",
    "NoicePopupBorder",
    "NoiceSplit",
    "NoiceSplitBorder",
    "NoiceCmdlinePopup",
    "NoiceCmdlinePopupBorder",
    "NoiceCmdlinePopupTitle",

    -- neo-tree
    "NeoTreeNormal",
    "NeoTreeNormalNC",
    "NeoTreeEndOfBuffer",
    "NeoTreeFloatBorder",
    "NeoTreeWinSeparator",
    "NeoTreeCursorLine",
  }

  for _, group in ipairs(groups) do
    pcall(vim.api.nvim_set_hl, 0, group, { bg = "NONE", ctermbg = "NONE" })
  end

  -- Neo-tree rot/farbig neutralisieren
  pcall(vim.api.nvim_set_hl, 0, "NeoTreeGitModified", { link = "NeoTreeFileName" })
  pcall(vim.api.nvim_set_hl, 0, "NeoTreeModified", { link = "NeoTreeFileName" })
end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = transparent,
})

vim.api.nvim_create_autocmd({ "TermOpen", "FileType" }, {
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    local bt = vim.bo[args.buf].buftype

    if bt == "terminal" or ft == "neo-tree" or ft == "snacks_terminal" then
      vim.opt_local.winbar = ""
      vim.opt_local.statusline = ""
    end
  end,
})

transparent()
