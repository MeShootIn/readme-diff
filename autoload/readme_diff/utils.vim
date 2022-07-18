function! readme_diff#utils#tcd(path) abort
  exec 'tcd' fnameescape(a:path)
endfunction

" NOTE Works only with '/'.
function! readme_diff#utils#path_join(...) abort
  return join(a:000, '/')
endfunction

function! readme_diff#utils#mkdirs(...) abort
  for dir_name in a:000
    let mkdir_result = mkdir(dir_name, 'p', 0400)

    if mkdir_result == v:false
      throw 'error creating directory "' .. dir_name .. '"'
    endif
  endfor
endfunction

" LOG LEVELS {{{

function! readme_diff#utils#TITLE() abort
  return 'TITLE'
endfunction

function! readme_diff#utils#OK() abort
  return 'OK'
endfunction

function! readme_diff#utils#INFO() abort
  return 'INFO'
endfunction

function! readme_diff#utils#ERROR() abort
  return 'ERROR'
endfunction

"  }}}

function! readme_diff#utils#log(level, ...) abort
  if a:level ==# readme_diff#utils#TITLE()
    echohl Title
  elseif a:level ==# readme_diff#utils#OK()
    echohl String
  elseif a:level ==# readme_diff#utils#INFO()
    echohl Normal
  elseif a:level ==# readme_diff#utils#ERROR()
    echohl ErrorMsg
  else
    throw 'unknown log level'
  endif

  for msg in a:000
    echomsg readme_diff#README_DIFF() .. ': ' .. msg
  endfor

  echohl None
endfunction

function! readme_diff#utils#directory_contents(directory) abort
  let cwd = getcwd()
  call readme_diff#utils#tcd(a:directory)
  let directory_contents = split(globpath('.', '*'), '\n')
        \ ->map({ _, file -> file[2:] })
  call readme_diff#utils#tcd(cwd)

  return directory_contents
endfunction
