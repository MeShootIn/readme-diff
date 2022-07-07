function! readme_diff#utils#path_join(...) abort
  return join(a:000, '/')
endfunction

function! readme_diff#utils#echo_oks(...) abort
  echohl String

  for ok in a:000
    echomsg readme_diff#README_DIFF() .. ': ' .. ok
  endfor

  echohl None
endfunction

function! readme_diff#utils#echo_errs(...) abort
  echohl ErrorMsg

  for err in a:000
    echomsg readme_diff#README_DIFF() .. ': ' .. err
  endfor

  echohl None
endfunction
