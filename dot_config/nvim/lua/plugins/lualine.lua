return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- =========================
      -- FARBEN HIER ÄNDERN
      -- =========================

      local BAR_BG = "#101010" -- Hintergrund der Blöcke
      local BAR_FG = "#dddddd" -- Textfarbe der Blöcke

      local MODE_TEXT = "#000000" -- Text in den Mode-Blöcken
      local MODE_NORMAL = "#3f73cf" -- NORMAL
      local MODE_INSERT = "#76eec6" -- INSERT
      local MODE_VISUAL = "#b452cd" -- VISUAL
      local MODE_REPLACE = "#c1ffc1" -- REPLACE
      local MODE_COMMAND = "#7d26cd" -- COMMAND

      -- =========================
      -- ENDE FARBEN
      -- =========================

      local function has_git_branch()
        local gitsigns = vim.b.gitsigns_status_dict
        return gitsigns and gitsigns.head and gitsigns.head ~= ""
      end

      local function mode_color()
        local mode = vim.fn.mode()
        if mode:find("i") then
          return MODE_INSERT
        elseif mode:find("[vV]") or mode == "\22" then
          return MODE_VISUAL
        elseif mode:find("R") then
          return MODE_REPLACE
        elseif mode:find("c") then
          return MODE_COMMAND
        end
        return MODE_NORMAL
      end

      local function pill(component, extra)
        local c = type(component) == "table" and component or { component }
        c.separator = c.separator or { left = "", right = "" }
        c.padding = c.padding or { left = 1, right = 1 }
        c.color = vim.tbl_extend("force", {
          bg = BAR_BG,
          fg = BAR_FG,
        }, extra or {})
        return c
      end

      opts.options = opts.options or {}
      opts.options.globalstatus = true
      opts.options.component_separators = { left = "", right = "" }
      opts.options.section_separators = { left = "", right = "" }

      -- DAS ist für die freie Fläche der Leiste
      local theme = require("lualine.themes.auto")
      for _, mode in ipairs({ "normal", "insert", "visual", "replace", "command", "inactive" }) do
        if theme[mode] and theme[mode].c then
          theme[mode].c.bg = "NONE"
        end
      end
      opts.options.theme = theme

      opts.sections = {
        lualine_a = {
          {
            "mode",
            separator = { left = "", right = "" },
            padding = { left = 1, right = 1 },
            color = function()
              return { bg = mode_color(), fg = MODE_TEXT, gui = "bold" }
            end,
          },
        },

        lualine_b = {
          {
            "branch",
            cond = has_git_branch,
            separator = { left = "", right = "" },
            padding = { left = 1, right = 1 },
            color = { bg = BAR_BG, fg = BAR_FG },
          },
        },

        lualine_c = {
          {
            "filename",
            path = 1,
            separator = { left = "", right = "" },
            padding = { left = 1, right = 1 },
            color = { bg = BAR_BG, fg = BAR_FG },
            symbols = {
              modified = " [+]",
              readonly = " ",
              unnamed = "[No Name]",
              newfile = "[New]",
            },
          },
        },

        lualine_x = {
          pill("filetype"),
        },

        lualine_y = {
          pill("progress"),
          pill("location"),
        },

        lualine_z = {},
      }

      return opts
    end,

    config = function(_, opts)
      require("lualine").setup(opts)

      local function clear_bg(group)
        local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
        if ok then
          hl.bg = nil
          hl.ctermbg = nil
          vim.api.nvim_set_hl(0, group, {
            fg = hl.fg,
            bg = hl.bg,
            sp = hl.sp,
            bold = hl.bold,
            italic = hl.italic,
            underline = hl.underline,
            undercurl = hl.undercurl,
            reverse = hl.reverse,
            nocombine = hl.nocombine,
            link = hl.link,
          })
        end
      end

      local function fix_statusline_bg()
        for _, group in ipairs({
          "StatusLine",
          "StatusLineNC",
          "lualine_c_normal",
          "lualine_c_insert",
          "lualine_c_visual",
          "lualine_c_replace",
          "lualine_c_command",
          "lualine_c_inactive",
        }) do
          clear_bg(group)
        end
      end

      fix_statusline_bg()

      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          fix_statusline_bg()
        end,
      })
    end,
  },
}
