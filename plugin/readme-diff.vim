" COMMON {{{

function! s:path_join(...) abort
  return join(a:000, '/')
endfunction

function! s:echo_errs(...) abort
  echohl ErrorMsg

  for err in a:000
    echomsg s:PLUGIN_NAME .. ': ' .. err
  endfor

  echohl None
endfunction

function! s:echo_oks(...) abort
  echohl Normal

  for ok in a:000
    echomsg s:PLUGIN_NAME .. ': ' .. ok
  endfor

  echohl None
endfunction

" }}}

let s:PLUGIN_NAME = 'readme-diff'
let s:DATA_PATH = stdpath('data')
let s:PACKER_PATH = s:path_join(s:DATA_PATH, 'site/pack/packer')
let s:README_DIFF_PATH = s:path_join(s:DATA_PATH, 'readme-diff')
let s:COMMIT_PATH = s:path_join(s:README_DIFF_PATH, 'saved-commit-ids')

" STARTUP {{{

function! s:init() abort
  " INFO 400 - read-only (for all groups)
  call mkdir(s:README_DIFF_PATH, 'p', 0400)
  call mkdir(s:COMMIT_PATH, 'p', 0400)
endfunction

" }}}

" SERVICE FUNCTIONS {{{

" NOTE `plugin` = `plugin_name` / `user_name/plugin_name`; `plugin_full_name` =
" `user_name/plugin_name`

function! s:plugin_name(plugin) abort
  return trim(split(a:plugin, '/')[-1])
endfunction

function! s:github_compare_link(
      \ plugin_full_name, base_commit_id, compare_commit_id
      \ ) abort
  return s:path_join(
        \ 'https://github.com', a:plugin_full_name, 'compare', a:base_commit_id
        \ .. '..' .. a:compare_commit_id
        \ )
endfunction

" TODO Search not only in `packer` directories.
function! s:last_commit_id(plugin) abort
  const plugin_name = s:plugin_name(a:plugin)
  const plugin_path = finddir(plugin_name, s:PACKER_PATH .. '/**1')

  if plugin_path ==# ''
    throw 'could not find plugin directory "' .. plugin_name .. '" in "'
          \ .. s:PACKER_PATH .. '" directory'
  endif

  const git_command = 'git log --format="%H" -n 1'
  const last_commit_id = trim(system('cd "' .. plugin_path .. '"' .. ' && '
        \ .. git_command
        \ ))

  if v:shell_error != 0
    throw 'error while getting last commit id (bash: "' .. git_command .. '")'
  endif

  return last_commit_id
endfunction

function! s:saved_commit_id(plugin) abort
  const plugin_name = s:plugin_name(a:plugin)
  const file_path = findfile(plugin_name, s:COMMIT_PATH)

  if file_path ==# ''
    throw 'could not find plugin file "' .. plugin_name .. '" in "'
          \ .. s:COMMIT_PATH .. '" directory'
  endif

  let file_content = readfile(file_path)

  if len(file_content) == 0
    throw 'file "' .. file_path .. '" is empty'
  endif

  let saved_commit_id = file_content[0]

  return saved_commit_id
endfunction

" }}}

" COMMAND FUNCTIONS {{{

function! s:add_plugin(plugin) abort
  " TODO Transfer to the `STARTUP` section.
  call s:init()

  const plugin_name = s:plugin_name(a:plugin)
  const file_path = s:path_join(s:COMMIT_PATH, plugin_name)

  try
    const last_commit_id = s:last_commit_id(a:plugin)
    const writefile_result = writefile([last_commit_id], file_path, 'b')

    if writefile_result != 0
      throw 'error writing to file "' .. file_path .. '"'
    endif

    call s:echo_oks(
          \ '"' .. plugin_name .. '" plugin last commit was successfully SAVED'
          \ )
  catch
    call s:echo_errs(v:exception)
  endtry
endfunction

function! s:remove_plugin(plugin) abort
  " TODO Transfer to the `STARTUP` section.
  call s:init()

  const plugin_name = s:plugin_name(a:plugin)
  const file_path = findfile(plugin_name, s:COMMIT_PATH)

  try
    if file_path ==# ''
      throw 'could not find plugin file "' .. plugin_name .. '" in "'
            \ .. s:COMMIT_PATH .. '" directory'
    endif

    const delete_result = delete(file_path)

    if delete_result != 0
      throw 'error deleting file "' .. file_path .. '"'
    endif

    call s:echo_oks(
          \ '"' .. plugin_name .. '" plugin last commit was successfully'
          \ .. ' REMOVED'
          \ )
  catch
    call s:echo_errs(v:exception)
  endtry
endfunction

" }}}

" COMMANDS {{{

command! -nargs=1 ReadmeDiffAdd call s:add_plugin(<f-args>)
command! -nargs=1 ReadmeDiffRemove call s:remove_plugin(<f-args>)

" }}}
