local status, _ = pcall(require, "moonfly")
if not status then
	return
end
vim.cmd [[colorscheme moonfly]]
