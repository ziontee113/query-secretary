--> Add plenary
local plenary_dir =
    "/home/ziontee113/.local/share/nvim/site/pack/packer/start/plenary.nvim/"

vim.opt.rtp:append "."
vim.opt.rtp:append(plenary_dir)
require "plenary.busted"

--> Add Treesitter

-- local treesitter_dir =
--     "home/ziontee113/.local/share/nvim/site/pack/packer/opt/nvim-treesitter"
-- vim.opt.rtp:append(treesitter_dir)
--
-- require "nvim-treesitter.query_predicates"

--> Minimal Init

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.smarttab = true
vim.o.expandtab = true

vim.o.swapfile = false
vim.bo.swapfile = false
