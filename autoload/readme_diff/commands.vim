function! readme_diff#commands#add_plugins(...) abort
  for plugin in a:000
    let plugin_name = readme_diff#services#plugin_name(plugin)
    let file_path = readme_diff#utils#path_join(
          \ readme_diff#COMMIT_PATH(), plugin_name
          \ )

    try
      let last_commit_id = readme_diff#services#last_commit_id(plugin)
      let writefile_result = writefile([last_commit_id], file_path, 'b')

      if writefile_result != 0
        throw 'error writing to file "' .. file_path .. '"'
      endif

      call readme_diff#utils#echo_oks(
            \ 'last commit of plugin "' .. plugin_name .. '" was successfully'
            \ .. ' SAVED'
            \ )
    catch
      call readme_diff#utils#echo_errs(v:exception)
    endtry
  endfor
endfunction

function! readme_diff#commands#remove_plugins(...) abort
  for plugin in a:000
    let plugin_name = readme_diff#services#plugin_name(plugin)
    let file_path = findfile(plugin_name, readme_diff#COMMIT_PATH())

    try
      if file_path ==# ''
        throw 'could not find plugin file "' .. plugin_name .. '" in "'
              \ .. readme_diff#COMMIT_PATH() .. '" directory'
      endif

      let delete_result = delete(file_path)

      if delete_result != 0
        throw 'error deleting file "' .. file_path .. '"'
      endif

      call readme_diff#utils#echo_oks(
            \ 'last commit of plugin "' .. plugin_name .. '" was successfully'
            \ .. ' REMOVED'
            \ )
    catch
      call readme_diff#utils#echo_errs(v:exception)
    endtry
  endfor
endfunction

" TODO Walk through all saved commit id files.
" function! readme_diff#commands#check() abort
" endfunction

" TODO Retrieve `plugin_full_name` from `plugin_name`.
function! readme_diff#commands#diff(...) abort
  for plugin in a:000
    try
      let plugin_name = readme_diff#services#plugin_name(plugin)
      let base_commit_id = readme_diff#services#saved_commit_id(plugin_name)
      let compare_commit_id = readme_diff#services#last_commit_id(plugin_name)

      if base_commit_id !=# compare_commit_id
        call readme_diff#utils#echo_oks(
              \ plugin .. ': '..
              \ readme_diff#services#github_compare_url(
              \ plugin,
              \ base_commit_id,
              \ compare_commit_id
              \ )
              \ )
      endif
    catch
      call readme_diff#utils#echo_errs(v:exception)
    endtry
  endfor
endfunction
