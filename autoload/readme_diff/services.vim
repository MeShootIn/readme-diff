" NOTE `plugin` = `plugin_name` or `user_name/plugin_name`; `plugin_full_name`
" = `user_name/plugin_name`

function! readme_diff#services#plugin_name(plugin) abort
  return trim(split(a:plugin, '/')[-1])
endfunction

function! readme_diff#services#github_compare_url(
      \ plugin_full_name, base_commit_id, compare_commit_id
      \ ) abort
  return readme_diff#utils#path_join(
        \ 'https://github.com', a:plugin_full_name, 'compare', a:base_commit_id
        \ .. '..' .. a:compare_commit_id
        \ )
endfunction

" TODO Search not only in `packer` directories.
function! readme_diff#services#last_commit_id(plugin) abort
  const plugin_name = readme_diff#services#plugin_name(a:plugin)
  const plugin_path = finddir(plugin_name, readme_diff#PACKER_PATH() .. '/**1')

  if plugin_path ==# ''
    throw 'could not find plugin directory "' .. plugin_name .. '" in "'
          \ .. readme_diff#PACKER_PATH() .. '" directory'
  endif

  const git_command = 'git log --format="%H" -n 1'
  const last_commit_id = trim(system('cd "' .. plugin_path .. '"' .. ' && '
        \ .. git_command
        \ ))

  if v:shell_error != 0
    throw 'error getting last commit id (bash: "' .. git_command .. '") of'
          \ .. ' plugin "' .. a:plugin .. '"'
  endif

  return last_commit_id
endfunction

function! readme_diff#services#saved_commit_id(plugin) abort
  const plugin_name = readme_diff#services#plugin_name(a:plugin)
  const file_path = findfile(plugin_name, readme_diff#COMMIT_PATH())

  if file_path ==# ''
    throw 'could not find plugin file "' .. plugin_name .. '" in "'
          \ .. readme_diff#COMMIT_PATH() .. '" directory'
  endif

  const file_content = readfile(file_path)

  if len(file_content) == 0
    throw 'file "' .. file_path .. '" is empty'
  endif

  const saved_commit_id = trim(file_content[-1])

  return saved_commit_id
endfunction
