local status, _ = pcall(require, "nightfly")
if not status then
  return
end
vim.cmd [[colorscheme nightfly]]
vim.cmd [[hi def IlluminatedWordText gui=underline]]
vim.cmd [[hi def IlluminatedWordRead gui=underline]]
vim.cmd [[hi def IlluminatedWordWrite gui=underline]]
