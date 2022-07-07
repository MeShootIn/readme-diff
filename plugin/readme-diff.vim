" TODO Remove `has('nvim-...')` check when the whole Neovim folder search is
" implemented
" if exists('g:loaded_readme_diff') || !has('nvim-0.5.0') | finish | endif
" let g:loaded_readme_diff = v:true

" INIT {{{

function! s:init() abort
  const mkdir_rdp = mkdir(readme_diff#README_DIFF_PATH(), 'p', 0400)

  if mkdir_rdp == v:false
    throw 'error creating directory "' .. readme_diff#README_DIFF_PATH() .. '"'
  endif

  const mkdir_cp = mkdir(readme_diff#COMMIT_PATH(), 'p', 0400)

  if mkdir_cp == v:false
    throw 'error creating directory "' .. readme_diff#COMMIT_PATH() .. '"'
  endif
endfunction

try
  call s:init()
catch
  call readme_diff#utils#echo_errs(v:exception)

  finish
endtry

" }}}

" COMMANDS {{{

command! -nargs=+ ReadmeDiff call readme_diff#commands#diff(<f-args>)
command! -nargs=+ ReadmeDiffAdd call readme_diff#commands#add_plugins(<f-args>)
command! -nargs=+ ReadmeDiffRemove call readme_diff#commands#remove_plugins(
      \ <f-args>
      \ )

" }}}
