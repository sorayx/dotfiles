return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {}

      local function snacks_action(kind, opts)
        return function()
          pcall(function()
            require("lazy").load({ plugins = { "snacks.nvim" } })
          end)
          if _G.Snacks and Snacks.dashboard and Snacks.dashboard.pick then
            Snacks.dashboard.pick(kind, opts or {})
          end
        end
      end

      local function alpha_button(sc, txt, on_press)
        local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")
        return {
          type = "button",
          val = txt,
          on_press = on_press,
          opts = {
            position = "center",
            shortcut = sc,
            cursor = 3,
            width = 50,
            align_shortcut = "right",
            hl_shortcut = "Keyword",
            keymap = {
              "n",
              sc_,
              on_press,
              { noremap = true, silent = true, nowait = true },
            },
          },
        }
      end

      dashboard.section.buttons.val = {
        alpha_button("f", "  Find file", snacks_action("files")),
        alpha_button("n", "  New file", function()
          vim.cmd("ene")
        end),
        alpha_button("r", "  Recent files", snacks_action("oldfiles")),
        alpha_button("P", "  Projects (util.project)", snacks_action("projects")),
        alpha_button("p", "  Projects", snacks_action("projects")),
        alpha_button("g", "  Find text", snacks_action("live_grep")),
        alpha_button("c", "  Config", snacks_action("files", { cwd = vim.fn.stdpath("config") })),
        alpha_button("s", "  Restore Session", function()
          local ok, p = pcall(require, "persistence")
          if ok then
            p.load()
          end
        end),
        alpha_button("x", "  Lazy Extras", function()
          vim.cmd("LazyExtras")
        end),
        alpha_button("l", "󰒲  Lazy", function()
          vim.cmd("Lazy")
        end),
        alpha_button("q", "  Quit", function()
          vim.cmd("qa")
        end),
      }

      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end

      dashboard.section.buttons.opts = dashboard.section.buttons.opts or {}
      dashboard.section.buttons.opts.position = "center"

      dashboard.section.footer.opts = dashboard.section.footer.opts or {}
      dashboard.section.footer.opts.position = "center"

      local orig_footer = dashboard.section.footer.val
      dashboard.section.footer.val = function()
        local v = (type(orig_footer) == "function") and orig_footer() or orig_footer

        local function strip_bolt(s)
          if type(s) ~= "string" then
            return s
          end
          return (s:gsub("^%s*⚡%s*", ""))
        end

        if type(v) == "table" then
          for i = 1, #v do
            v[i] = strip_bolt(v[i])
          end
          return v
        end
        return strip_bolt(v)
      end

      local function top_padding()
        local win_h = vim.fn.winheight(0)
        local btn_count = #(dashboard.section.buttons.val or {})
        local footer_lines = 1
        local content_h = btn_count + footer_lines + 2
        local pad = math.floor((win_h - content_h) / 2) - 1
        if pad < 1 then
          pad = 1
        end
        return pad
      end

      dashboard.config.layout = {
        { type = "padding", val = top_padding },
        dashboard.section.buttons,
        { type = "padding", val = 1 },
        dashboard.section.footer,
      }

      local group = vim.api.nvim_create_augroup("AlphaDashNav", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "alpha",
        callback = function(ev)
          local map = function(lhs, rhs)
            vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, silent = true, noremap = true })
          end

          map("j", "<Down>")
          map("k", "<Up>")

          if vim.fn.exists(":LazyExtras") ~= 2 then
            map("x", "<cmd>Lazy<cr>")
          end
        end,
      })

      return dashboard
    end,
    config = function(_, dashboard)
      require("alpha").setup(dashboard.opts)
    end,
  },
}
