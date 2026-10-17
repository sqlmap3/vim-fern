if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

setlocal cursorline
setlocal nolist nowrap nospell
setlocal tabstop=1

" Re-assert conceal on EVERY entry into the fern window.
" indentLine (after/plugin/indentLine.vim) registers a BufWinEnter autocmd in
" after/plugin (loaded before FileType), which calls IndentLinesDisable ->
" ResetConcealOption: that restores &conceallevel to the value it stashed on
" first entry (0 for fern, since fern had not rendered yet) and then skips
" re-applying its own value because b:indentLine_ConcealOptionSet is already 1.
" The net effect: &conceallevel is dropped to 0 and never put back, exposing the
" 0x1F badge separator in autoload/fern/renderer/default.vim as a literal ^_.
" This ftplugin is sourced on FileType (before BufWinEnter), so these autocmds
" are registered AFTER indentLine's; BufEnter/WinEnter in particular fire later
" than indentLine's BufWinEnter, so they reliably win the option back on every
" kind of window/buffer entry.
augroup fern_conceal
  autocmd! * <buffer>
  autocmd BufWinEnter,BufEnter,WinEnter <buffer> setlocal concealcursor=nvic conceallevel=2
augroup END
