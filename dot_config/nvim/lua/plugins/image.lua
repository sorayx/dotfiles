return {
  {
    "3rd/image.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      backend = "sixel",
      processor = "magick_cli",

      max_width = 150,
      max_height = 50,
      max_width_window_percentage = 75,
      max_height_window_percentage = 75,

      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          floating_windows = false,
          filetypes = { "markdown", "vimwiki" },
        },
      },
    },
  },
}
