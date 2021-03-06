" VimTeX - LaTeX plugin for Vim
"
" Maintainer: Karl Yngve Lervåg
" Email:      karl.yngve@gmail.com
"

function! vimtex#view#skim#new() abort " {{{1
  augroup vimtex_view_skim
    autocmd!
    autocmd User VimtexEventCompileSuccess
            \ call vimtex#view#skim#compiler_callback()
  augroup END

  return vimtex#view#_template#apply(deepcopy(s:skim))
endfunction

" }}}1
function! vimtex#view#skim#compiler_callback() abort " {{{1
  if !exists('b:vimtex.viewer') | return | endif
  let self = b:vimtex.viewer
  if !filereadable(self.out()) | return | endif
  if !self.skim_available() | return | endif

  let self.cmd_view_callback = join([
        \ 'osascript',
        \ '-e ''set theFile to POSIX file "' . self.out() . '"''',
        \ '-e ''set thePath to POSIX path of (theFile as alias)''',
        \ '-e ''tell application "Skim"''',
        \ '-e ''try''',
        \ '-e ''set theDocs to get documents whose path is thePath''',
        \ '-e ''if (count of theDocs) > 0 then revert theDocs''',
        \ '-e ''end try''',
        \ '-e ''open theFile''',
        \ '-e ''end tell''',
        \])

  call vimtex#jobs#run(self.cmd_view_callback)
endfunction

" }}}1


let s:skim = {
      \ 'name' : 'Skim',
      \ 'startskim' : 'open -a Skim',
      \ '_requirements_checked' : v:false,
      \ '_skim_available' : v:false,
      \}

function! s:skim.skim_available() abort " {{{1
  if !self._requirements_checked
    let self._requirements_checked = v:true

    " Check if Skim is installed
    let l:output = vimtex#jobs#capture(
          \ 'osascript -e '
          \ . '''tell application "Finder" to get id of application "Skim"''')
    let self._skim_available = l:output[0] =~# '^net.sourceforge.skim-app'
    if !self._skim_available
      call vimtex#log#error('Skim is not installed!')
    endif
  endif

  return self._skim_available
endfunction

" }}}1
function! s:skim.view(file) dict abort " {{{1
  if !self.skim_available() | return | endif

  if empty(a:file)
    let outfile = self.out()

    " Only copy files if they don't exist
    if g:vimtex_view_use_temp_files && !filereadable(outfile)
      call self.copy_files()
    endif
  else
    let outfile = a:file
  endif
  if vimtex#view#not_readable(outfile) | return | endif

  let self.cmd_view = join([
        \ 'osascript',
        \ '-e ''set theLine to ' . line('.') . ' as integer''',
        \ '-e ''set theFile to POSIX file "' . outfile . '"''',
        \ '-e ''set thePath to POSIX path of (theFile as alias)''',
        \ '-e ''set theSource to POSIX file "' . expand('%:p') . '"''',
        \ '-e ''tell application "Skim"''',
        \ '-e ''try''',
        \ '-e ''set theDocs to get documents whose path is thePath''',
        \ '-e ''if (count of theDocs) > 0 then revert theDocs''',
        \ '-e ''end try''',
        \ '-e ''open theFile''',
        \ '-e ''tell front document to go to TeX line theLine from theSource',
        \ g:vimtex_view_skim_reading_bar ? 'showing reading bar true''' : '''',
        \ g:vimtex_view_skim_activate ? '-e ''activate''' : '',
        \ '-e ''end tell''',
        \])

  call vimtex#jobs#run(self.cmd_view)

  if exists('#User#VimtexEventView')
    doautocmd <nomodeline> User VimtexEventView
  endif
endfunction

" }}}1
function! s:skim.latexmk_append_argument() dict abort " {{{1
  if g:vimtex_view_use_temp_files || g:vimtex_view_automatic
    return ' -view=none'
  else
    return vimtex#compiler#latexmk#wrap_option('pdf_previewer', self.startskim)
  endif
endfunction

" }}}1
