set colorcolumn=81

" Do not spell comments in LaTex
let g:vimtex_syntax_nospell_comments=1


" Only check spelling in LaTex files
" autocmd BufRead,BufNewFile *.tex set spelllang=en,es spell

vnoremap <leader>i c\textit{<c-r>"}
vnoremap <leader>b c\textbf{<c-r>"}
vnoremap <leader>v c\verb\|<c-r>"\|

nnoremap <leader>v a\verb\|\|<ESC>i
nnoremap <leader>i a\textit{}<ESC>i
nnoremap <leader>d a\textbf{}<ESC>i
nnoremap <leader>c a~\cite{}<ESC>i
nnoremap <leader>r a~\ref{}<ESC>i
nnoremap <leader>fu a\footnote{\url{}}<ESC>hi
nnoremap <leader>x :!./compile
nnoremap <leader>. f.lxi<CR><ESC>
