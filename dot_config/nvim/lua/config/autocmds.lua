local function transparent()
  local groups = {
    "Normal",
    "NormalNC",
    "SignColumn",
    "EndOfBuffer",
    "LineNr",
    "FoldColumn",
    "NormalFloat",
    "FloatBorder",
    "FloatTitle",
    "WinBar",
    "WinBarNC",
    "StatusLine",
    "StatusLineNC",
    "MsgArea",
    "MsgSeparator",
    "NoicePopup",
    "NoicePopupBorder",
    "NoiceSplit",
    "NoiceSplitBorder",
    "NoiceCmdlinePopup",
    "NoiceCmdlinePopupBorder",
    "NoiceCmdlinePopupTitle",
    "NeoTreeNormal",
    "NeoTreeNormalNC",
    "NeoTreeEndOfBuffer",
    "NeoTreeFloatBorder",
    "NeoTreeCursorLine",

    -- bufferline / tabline transparent
    "BufferLineFill",
    "BufferLineBackground",
    "BufferLineBuffer",
    "BufferLineTab",
    "BufferLineTabClose",
    "BufferLineCloseButton",
    "BufferLineCloseButtonVisible",
    "BufferLineCloseButtonSelected",
    "BufferLineSeparator",
    "BufferLineSeparatorVisible",
    "BufferLineSeparatorSelected",
    "BufferLineOffsetSeparator",
    "TabLine",
    "TabLineFill",
  }

  for _, group in ipairs(groups) do
    pcall(vim.api.nvim_set_hl, 0, group, {
      bg = "NONE",
      ctermbg = "NONE",
    })
  end

  pcall(vim.api.nvim_set_hl, 0, "WinSeparator", { link = "Normal" })
  pcall(vim.api.nvim_set_hl, 0, "VertSplit", { link = "Normal" })
  pcall(vim.api.nvim_set_hl, 0, "NeoTreeWinSeparator", { link = "NeoTreeNormal" })

  pcall(vim.api.nvim_set_hl, 0, "NeoTreeGitModified", { link = "NeoTreeFileName" })
  pcall(vim.api.nvim_set_hl, 0, "NeoTreeModified", { link = "NeoTreeFileName" })
end

local function apply_ui_overrides()
  transparent()

  -- aktiver tab: transparent, nur hellere schrift
  vim.api.nvim_set_hl(0, "BufferLineBufferSelected", {
    bg = "NONE",
    fg = "#f5e0dc",
    bold = true,
    italic = false,
  })

  vim.api.nvim_set_hl(0, "BufferLineTabSelected", {
    bg = "NONE",
    fg = "#f5e0dc",
    bold = true,
    italic = false,
  })

  vim.api.nvim_set_hl(0, "TabLineSel", {
    bg = "NONE",
    fg = "#f5e0dc",
    bold = true,
  })

  -- inaktive tabs: leicht ausgegraut
  vim.api.nvim_set_hl(0, "BufferLineBackground", {
    bg = "NONE",
    fg = "#999999",
  })

  vim.api.nvim_set_hl(0, "BufferLineBuffer", {
    bg = "NONE",
    fg = "#999999",
  })

  vim.api.nvim_set_hl(0, "BufferLineTab", {
    bg = "NONE",
    fg = "#999999",
  })

  vim.api.nvim_set_hl(0, "TabLine", {
    bg = "NONE",
    fg = "#999999",
  })

  vim.api.nvim_set_hl(0, "TabLineFill", {
    bg = "NONE",
    fg = "#999999",
  })

  vim.api.nvim_set_hl(0, "BufferLineCloseButton", {
    bg = "NONE",
    fg = "#999999",
  })

  vim.api.nvim_set_hl(0, "BufferLineCloseButtonVisible", {
    bg = "NONE",
    fg = "#999999",
  })

  vim.api.nvim_set_hl(0, "BufferLineCloseButtonSelected", {
    bg = "NONE",
    fg = "#f5e0dc",
  })

  -- markierungen / separatoren weg
  vim.api.nvim_set_hl(0, "BufferLineIndicatorSelected", {
    fg = "NONE",
    bg = "NONE",
  })

  vim.api.nvim_set_hl(0, "BufferLineIndicatorVisible", {
    fg = "NONE",
    bg = "NONE",
  })

  vim.api.nvim_set_hl(0, "BufferLineIndicator", {
    fg = "NONE",
    bg = "NONE",
  })

  vim.api.nvim_set_hl(0, "BufferLineOffsetSeparator", {
    fg = "NONE",
    bg = "NONE",
  })

  vim.api.nvim_set_hl(0, "BufferLineSeparatorSelected", {
    fg = "NONE",
    bg = "NONE",
  })

  vim.api.nvim_set_hl(0, "BufferLineSeparatorVisible", {
    fg = "NONE",
    bg = "NONE",
  })

  vim.api.nvim_set_hl(0, "BufferLineSeparator", {
    fg = "NONE",
    bg = "NONE",
  })

  vim.api.nvim_set_hl(0, "BufferLineFill", {
    fg = "NONE",
    bg = "NONE",
  })
end

vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
  callback = apply_ui_overrides,
})

vim.api.nvim_create_autocmd({ "TermOpen", "FileType" }, {
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    local bt = vim.bo[args.buf].buftype

    if bt == "terminal" or ft == "neo-tree" or ft == "snacks_terminal" then
      vim.opt_local.winbar = ""
      vim.opt_local.statusline = ""
      vim.opt_local.winhighlight = "WinSeparator:Normal,VertSplit:Normal,NeoTreeWinSeparator:NeoTreeNormal"
    end
  end,
})

apply_ui_overrides()
