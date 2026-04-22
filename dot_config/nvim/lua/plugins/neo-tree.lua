return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    default_component_configs = {
      name = {
        use_git_status_colors = false,
      },
      modified = {
        symbol = "",
      },
      diagnostics = {
        symbols = {
          hint = "",
          info = "",
          warn = "",
          error = "",
        },
      },
      git_status = {
        symbols = {
          added = "",
          modified = "",
          deleted = "",
          renamed = "",
          untracked = "",
          ignored = "",
          unstaged = "",
          staged = "",
          conflict = "",
        },
      },
    },
  },
}
