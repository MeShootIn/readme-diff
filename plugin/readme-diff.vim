if exists('g:loaded_readme_diff') | finish | endif
let g:loaded_readme_diff = v:true

" INIT {{{

function! s:init() abort
  if !has('nvim-' .. readme_diff#MIN_VERSION())
    throw 'Neovim version must be at least ' .. readme_diff#MIN_VERSION()
  endif

  call readme_diff#utils#mkdirs(
        \ readme_diff#README_DIFF_PATH(),
        \ readme_diff#COMMIT_PATH()
        \ )
endfunction

try
  call s:init()
catch
  call readme_diff#utils#log(readme_diff#utils#ERROR(), v:exception)

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
