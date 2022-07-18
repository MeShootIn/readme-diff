" TODO Make cmd output shorter (for ALL commands).
" TODO Fuzzy find.
" TODO Iterative -> job: https://youtu.be/bXS8kdvo-0M?list=PLOe6AggsTaVv_IQsADuzhOzepA_tSAagN

" ADDING PLUGINS {{{

" TODO Plugin's last commit id update notification.
function! readme_diff#commands#add_plugins(...) abort
  call readme_diff#utils#log(readme_diff#utils#TITLE(), 'ADDING PLUGINS')

  let plugins = a:000

  if a:0 == 1 && a:1 ==# '*'
    let packer_directories = readme_diff#utils#directory_contents(
          \ readme_diff#PACKER_PATH()
          \ )
    let all_plugin_names = {}

    for packer_directory in packer_directories
      let plugin_names = readme_diff#utils#directory_contents(
            \ readme_diff#utils#path_join(
            \ readme_diff#PACKER_PATH(),
            \ packer_directory
            \ )
            \ )

      for plugin_name in plugin_names
        let all_plugin_names[plugin_name] = plugin_name
      endfor
    endfor

    let plugins = keys(all_plugin_names)
  endif

  for plugin in plugins
    let plugin_name = readme_diff#services#plugin_name(plugin)
    let saved_commit_id_file = readme_diff#utils#path_join(
          \ readme_diff#COMMIT_PATH(), plugin_name
          \ )

    try
      let last_commit_id = readme_diff#services#last_commit_id(plugin)
      let writefile_result = writefile([last_commit_id],
            \ saved_commit_id_file, 'b')

      if writefile_result != 0
        throw 'error writing to file "' .. saved_commit_id_file .. '"'
      endif

      call readme_diff#utils#log(readme_diff#utils#OK(),
            \ 'last commit of plugin "' .. plugin_name .. '" was successfully'
            \ .. ' SAVED'
            \ )
    catch
      call readme_diff#utils#log(readme_diff#utils#ERROR(), v:exception)
    endtry
  endfor

  call readme_diff#utils#log(readme_diff#utils#TITLE(), 'ADDING PLUGINS')
endfunction

"  }}}

" REMOVING PLUGINS {{{

function! readme_diff#commands#remove_plugins(...) abort
  call readme_diff#utils#log(readme_diff#utils#TITLE(), 'REMOVING PLUGINS')

  let plugins = a:000

  if a:0 == 1 && a:1 ==# '*'
    let plugins = readme_diff#utils#directory_contents(
          \ readme_diff#COMMIT_PATH()
          \ )
  endif

  for plugin in plugins
    let plugin_name = readme_diff#services#plugin_name(plugin)
    let saved_commit_id_file = findfile(plugin_name, readme_diff#COMMIT_PATH())

    try
      if saved_commit_id_file ==# ''
        throw 'could not find plugin file "' .. plugin_name .. '" in "'
              \ .. readme_diff#COMMIT_PATH() .. '" directory'
      endif

      let delete_result = delete(saved_commit_id_file)

      if delete_result != 0
        throw 'error deleting file "' .. saved_commit_id_file .. '"'
      endif

      call readme_diff#utils#log(readme_diff#utils#OK(),
            \ 'last commit of plugin "' .. plugin_name .. '" was successfully'
            \ .. ' REMOVED'
            \ )
    catch
      call readme_diff#utils#log(readme_diff#utils#ERROR(), v:exception)
    endtry
  endfor

  call readme_diff#utils#log(readme_diff#utils#TITLE(), 'REMOVING PLUGINS')
endfunction

"  }}}

" PLUGIN DIFFS {{{

function! readme_diff#commands#diff(...) abort
  call readme_diff#utils#log(readme_diff#utils#TITLE(), 'PLUGIN DIFFS')

  let plugins = a:000

  if a:0 == 1 && a:1 ==# '*'
    let plugins = readme_diff#utils#directory_contents(
          \ readme_diff#COMMIT_PATH()
          \ )
  endif

  let plugin_full_names = {}

  for plugin in plugins
    try
      let plugin_full_names[plugin] = readme_diff#services#plugin_full_name(
            \ plugin
            \ )
    catch
      call readme_diff#utils#log(readme_diff#utils#ERROR(), v:exception)
    endtry
  endfor

  let was_diff = v:false

  for plugin_full_name in values(plugin_full_names)
    try
      let base_commit_id = readme_diff#services#saved_commit_id(
            \ plugin_full_name
            \ )
      let compare_commit_id = readme_diff#services#last_commit_id(
            \ plugin_full_name
            \ )

      if base_commit_id !=# compare_commit_id
        call readme_diff#utils#log(
              \ readme_diff#utils#OK(),
              \ plugin_full_name .. ' -> '..
              \ readme_diff#services#github_compare_url(
              \ plugin_full_name,
              \ base_commit_id,
              \ compare_commit_id
              \ )
              \ )

        let was_diff = v:true
      else
        call readme_diff#utils#log(readme_diff#utils#INFO(), plugin_full_name
              \ .. " -> there isn't anything to compare"
              \ )
      endif
    catch
      call readme_diff#utils#log(readme_diff#utils#ERROR(), v:exception)
    endtry
  endfor

  if was_diff
    call readme_diff#utils#log(readme_diff#utils#INFO(),
          \ 'find the needed file ("README.md", ...) and click on the " "'
          \ .. ' button (to display the rich diff) OR create a gist'
          \ .. ' (https://gist.github.com) from two consecutive commits')
  endif

  call readme_diff#utils#log(readme_diff#utils#TITLE(), 'PLUGIN DIFFS')
endfunction

"  }}}
