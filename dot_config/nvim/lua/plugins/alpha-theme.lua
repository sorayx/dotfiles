return {
  {
    "goolord/alpha-nvim",
    opts = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- Logo/Header weg
      dashboard.section.header.val = {}

      -- Hilfsfunktion: Snacks pick (statt Telescope)
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

      -- Buttons (echte Alpha-Buttons -> auswählbar + Enter)
      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find file", snacks_action("files")),
        dashboard.button("n", "  New file", ":ene<CR>"),
        dashboard.button("r", "  Recent files", snacks_action("oldfiles")),
        dashboard.button("P", "  Projects (util.project)", snacks_action("projects")),
        dashboard.button("p", "  Projects", snacks_action("projects")),
        dashboard.button("g", "  Find text", snacks_action("live_grep")),
        dashboard.button("c", "  Config", snacks_action("files", { cwd = vim.fn.stdpath("config") })),
        dashboard.button("s", "  Restore Session", function()
          local ok, p = pcall(require, "persistence")
          if ok then
            p.load()
          end
        end),
        dashboard.button("x", "  Lazy Extras", ":LazyExtras<CR>"),
        dashboard.button("l", "󰒲  Lazy", ":Lazy<CR>"),
        dashboard.button("q", "  Quit", ":qa<CR>"),
      }

      -- Horizontal mittig
      dashboard.section.buttons.opts = dashboard.section.buttons.opts or {}
      dashboard.section.buttons.opts.position = "center"

      -- Footer behalten, aber "⚡" entfernen (Plugins/ms bleibt)
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

      -- dynamisches Top-Padding (Start etwas höher)
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

      -- Navigation im Alpha-Buffer: hoch/runter + Enter
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
          map("<Down>", "<Down>")
          map("<Up>", "<Up>")
          map("<CR>", "<CR>")

          if vim.fn.exists(":LazyExtras") ~= 2 then
            map("x", "<cmd>Lazy<cr>")
          end
        end,
      })

      alpha.setup(dashboard.config)
      return dashboard
    end,
  },
}
