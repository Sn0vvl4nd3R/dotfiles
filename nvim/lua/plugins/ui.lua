return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local function dirname()
        return vim.fn.fnamemodify(vim.fn.expand("%:h"), ":.")
      end
      require("lualine").setup({
        options = {
          theme = "auto",
          section_separators = "",
          component_separators = "",
          globalstatus = true,
        },
        sections = {
          lualine_a = { { "mode", fmt = function(s) return s:sub(1, 1) end } },
          lualine_b = { "branch", "diff" },
          lualine_c = {
            { "diagnostics", symbols = { error = " ", warn = " ", info = " ", hint = " " } },
            { "filename", path = 1, newfile_status = true },
          },
          lualine_x = { "encoding", "filetype" },
          lualine_y = { "location" },
          lualine_z = { "progress" },
        },
        winbar = {},
        inactive_winbar = {},
      })
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "▎" },
          change = { text = "▎" },
          delete = { text = "▁" },
          topdelete = { text = "▔" },
          changedelete = { text = "▎" },
        },
        current_line_blame = true,
        current_line_blame_opts = { delay = 500 },
      })
    end,
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup({})
      wk.add({
        { "<leader>u", group = "Toggle/UI" },

        {
          "<leader>uw",
          function() vim.wo.wrap = not vim.wo.wrap end,
          desc = "Toggle wrap"
        },

        {
          "<leader>un",
          function()
            vim.wo.number = not vim.wo.number
            vim.wo.relativenumber = vim.wo.number
          end,
          desc = "Toggle line numbers"
        },

        {
          "<leader>ud",
          function()
            local cfg = vim.diagnostic.config()
            local vt = cfg.virtual_text
            local enabled = (vt == true) or (type(vt) == "table" and vt.enabled ~= false)
            vim.diagnostics.config({ virtual_text = not enabled })
          end,
          desc = "Toggle virtual diagnostics"
        },

        {
          "<leader>uc",
          function()
            if vim.wo.colorcolumn == "" then vim.wo.colorcolumn = "100" else vim.wo.colorcolumn = "" end
          end,
          desc = "Toggle colorcolumn"
        },

        {
          "<leader>uh",
          function() vim.cmd("LspToggleInlayHints") end,
          desc = "Toggle inlay hints",
        },
      })
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "│" },
      scope = { enabled = true, show_start = true, show_end = false },
    },
  },

  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      local notify = require("notify")
      notify.setup({
        stages = "fade_in_slide_out",
        timeout = 2000,
        render = "compact",
        background_colour = "#000000",
      })
      vim.notify = notify
    end,
  },
}
