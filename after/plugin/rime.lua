local ok, err = pcall(require, 'cmp')
if ok then
    err.register_source('rime', require('nvim-rime.cmp-rime').new())
end
