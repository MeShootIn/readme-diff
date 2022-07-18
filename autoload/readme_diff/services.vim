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

function! readme_diff#services#last_commit_id(plugin) abort
  const plugin_name = readme_diff#services#plugin_name(a:plugin)
  const plugin_dir = finddir(plugin_name, readme_diff#PACKER_PATH() .. '/**1')

  if plugin_dir ==# ''
    throw 'could not find plugin directory "' .. plugin_name .. '" in "'
          \ .. readme_diff#PACKER_PATH() .. '/**1" directories'
  endif

  const git_command = 'git log --format="%H" -n 1'
  const last_commit_id = trim(system('cd "' .. plugin_dir .. '"' .. ' && '
        \ .. git_command
        \ ))

  if v:shell_error != 0
    throw 'error getting last commit id (shell: "' .. git_command .. '") of'
          \ .. ' plugin "' .. a:plugin .. '"'
  endif

  return last_commit_id
endfunction

function! readme_diff#services#saved_commit_id(plugin) abort
  const plugin_name = readme_diff#services#plugin_name(a:plugin)
  const saved_commit_id_file = findfile(plugin_name, readme_diff#COMMIT_PATH())

  if saved_commit_id_file ==# ''
    throw 'could not find plugin file "' .. plugin_name .. '" in "'
          \ .. readme_diff#COMMIT_PATH() .. '" directory'
  endif

  const file_content = readfile(saved_commit_id_file)

  if len(file_content) == 0
    throw 'file "' .. saved_commit_id_file .. '" is empty'
  endif

  const saved_commit_id = trim(file_content[-1])

  return saved_commit_id
endfunction

function! readme_diff#services#plugin_full_name(plugin) abort
  const plugin_name = readme_diff#services#plugin_name(a:plugin)
  const plugin_file = finddir(plugin_name, readme_diff#PACKER_PATH() .. '/**1')

  if plugin_file ==# ''
    throw 'could not find plugin directory "' .. plugin_name .. '" in "'
          \ .. readme_diff#PACKER_PATH() .. '/**1" directories'
  endif

  const git_command = 'git config --get remote.origin.url'
  const system_output = system('cd "' .. plugin_file .. '" && ' .. git_command)

  if v:shell_error != 0
    throw 'error getting full name (shell: "' .. git_command .. '") of'
          \ .. ' plugin "' .. a:plugin .. '"'
  endif

  const colon_splitted = split(system_output, ':')[-1]
  const user_name = split(colon_splitted, '/')[-2]
  const plugin_full_name = readme_diff#utils#path_join(user_name, plugin_name)

  return plugin_full_name
endfunction
