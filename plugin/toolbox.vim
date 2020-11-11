function! Pretty_format()
py3 << EOF
import vim
import vimtoolbox

vim.current.buffer[:] = vimtoolbox.fmt(
    vim.current.buffer.options['filetype'],
    '\n'.join(vim.current.buffer[:])
    )

EOF

endfunction

command! PrettyFormat call Pretty_format()

command! -bar TurnOnScratchBuffer setlocal buflisted buftype=nofile bufhidden=hide noswapfile filetype=rst
command! -bar TurnOffScratchBuffer setlocal buftype= bufhidden= swapfile
command! -bar NewScratch new | TurnOnScratchBuffer

augroup scratch_buffers
    autocmd!
    autocmd StdinReadPre * TurnOnScratchBuffer
    autocmd VimEnter *
        \   if @% == '' && &buftype == ''
        \ |     TurnOnScratchBuffer
        \ | endif
    autocmd BufWritePost * ++nested
        \   if (empty(bufname()) || bufname() == '-stdin-') && &buftype == 'nofile'
        \ |     TurnOffScratchBuffer
        \ |     setlocal nomodified
        \ |     edit <afile>
        \ | endif
augroup END

