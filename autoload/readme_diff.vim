" 'readme-diff' plugin's global variables.

function! readme_diff#README_DIFF() abort
  return 'readme-diff'
endfunction

function! readme_diff#DATA_PATH() abort
  return stdpath('data')
endfunction

function! readme_diff#PACKER_PATH() abort
  return readme_diff#utils#path_join(
        \ readme_diff#DATA_PATH(), 'site/pack/packer'
        \ )
endfunction

function! readme_diff#README_DIFF_PATH() abort
  return readme_diff#utils#path_join(
        \ readme_diff#DATA_PATH(), readme_diff#README_DIFF()
        \ )
endfunction

function! readme_diff#COMMIT_PATH() abort
  return readme_diff#utils#path_join(
        \ readme_diff#README_DIFF_PATH(), 'saved-commit-ids'
        \ )
endfunction

function! readme_diff#MIN_VERSION() abort
  return '0.5.0'
endfunction
