return {
  {
    "zk-org/zk-nvim",
    keys = {
      { "<leader>zn", "<cmd>ZkNew { title = vim.fn.input('Title: ') }<cr>", desc = "New note" },
      { "<leader>zo", "<cmd>ZkNotes<cr>", desc = "Open notes" },
      { "<leader>zt", "<cmd>ZkTags<cr>", desc = "Tags" },
      { "<leader>zl", "<cmd>ZkLinks<cr>", desc = "Links" },
    },
    config = function()
      require("zk").setup({
        picker = "telescope",
      })
    end,
  },
}
