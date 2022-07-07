" Plugin global variables.

function! readme_diff#README_DIFF()
  return 'readme-diff'
endfunction

function! readme_diff#DATA_PATH()
  return stdpath('data')
endfunction

function! readme_diff#PACKER_PATH()
  return readme_diff#utils#path_join(
        \ readme_diff#DATA_PATH(), 'site/pack/packer'
        \ )
endfunction

function! readme_diff#README_DIFF_PATH()
  return readme_diff#utils#path_join(
        \ readme_diff#DATA_PATH(), readme_diff#README_DIFF()
        \ )
endfunction

function! readme_diff#COMMIT_PATH()
  return readme_diff#utils#path_join(
        \ readme_diff#README_DIFF_PATH(), 'saved-commit-ids'
        \ )
endfunction
