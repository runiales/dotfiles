let mapleader =","

if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
Plug 'tpope/vim-surround'
Plug 'preservim/nerdtree'
Plug 'nvim-lualine/lualine.nvim'
Plug 'junegunn/goyo.vim'
Plug 'vimwiki/vimwiki'
Plug 'tpope/vim-commentary'
Plug 'ap/vim-css-color'
"Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
call plug#end()

set title
set bg=light
hi clear SpellBad
hi SpellBad cterm=underline ctermfg=red
" Set style for gVim
hi SpellBad gui=undercurl
" ayuda con los archivos
set path +=**

set title
set bg=light
set notermguicolors
set mouse=a
set nohlsearch
set clipboard+=unnamedplus
set noshowmode
set noruler
set laststatus=0
set noshowcmd
colorscheme vim

" Some basics:
	nnoremap c "_c
	set nocompatible
	filetype plugin on
	syntax on
	set encoding=utf-8
	set number relativenumber
" Enable autocompletion:
	set wildmode=longest,list,full
" Disables automatic commenting on newline:
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" Perform dot commands over visual blocks:
	vnoremap . :normal .<CR>
" Goyo plugin makes text more readable when writing prose:
	map <leader>f :Goyo \| set bg=light \| set linebreak<CR>
	autocmd BufRead,BufNewFile /tmp/neomutt* let g:goyo_width=80
	autocmd BufRead,BufNewFile /tmp/neomutt* set tw=0
	" autocmd BufRead,BufNewFile /tmp/neomutt* setlocal fo+=aw
	autocmd BufRead,BufNewFile /tmp/neomutt* :Goyo | set bg=light
	autocmd BufRead,BufNewFile /tmp/neomutt* map ZZ :Goyo\|x!<CR>
	autocmd BufRead,BufNewFile /tmp/neomutt* map ZQ :Goyo\|q!<CR>
" Spell-check set to <leader>o, 'o' for 'orthography':
	map <leader>oe :setlocal spell! spelllang=es_ES<CR>
	map <leader>oi :setlocal spell! spelllang=en_US<CR>
" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
	set splitbelow splitright

" Nerd tree
	map <leader>n :NERDTreeToggle<CR>
	autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
    if has('nvim')
        let NERDTreeBookmarksFile = stdpath('data') . '/NERDTreeBookmarks'
    else
        let NERDTreeBookmarksFile = '~/.vim' . '/NERDTreeBookmarks'
    endif

" vimling:
	nm <leader><leader>d :call ToggleDeadKeys()<CR>
	imap <leader><leader>d <esc>:call ToggleDeadKeys()<CR>a
	nm <leader><leader>i :call ToggleIPA()<CR>
	imap <leader><leader>i <esc>:call ToggleIPA()<CR>a
	nm <leader><leader>q :call ToggleProse()<CR>

" Shortcutting split navigation, saving a keypress:
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l

" Copiapega
	vnoremap <C-c> "*y :let @+=@*<CR>
	map <C-p> "+P

" Replace ex mode with gq
	map Q gq

" Check file in shellcheck:
	map <leader>s :!clear && shellcheck -x %<CR>

" Open my bibliography file in split
	map <leader>b :vsp<space>$BIB<CR>
	map <leader>r :vsp<space>$REFER<CR>

" Replace all is aliased to S.
	nnoremap S :%s//g<Left><Left>

" Compile document, be it groff/LaTeX/markdown/etc.
	map <leader>c :w! \| !compiler "<c-r>%"<CR>

" Open corresponding .pdf/.html or preview
	map <leader>p :!opout <c-r>%<CR><CR>

" Runs a script that cleans out tex build files whenever I close out of a .tex file.
	autocmd VimLeave *.tex !texclear %

" Ensure files are read as what I want:
	let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
	map <leader>v :VimwikiIndex
	let g:vimwiki_list = [{'path': '~/Documentos/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
	autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
	autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
	autocmd BufRead,BufNewFile *.tex,*.lytex set filetype=tex

" Save file as sudo on files that require root permission
	cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!


" Automatically deletes all trailing whitespace and newlines at end of file on save.
	autocmd BufWritePre * %s/\s\+$//e
    autocmd BufWritePre * %s/\n\+\%$//e
    autocmd BufWritePre *.[ch] %s/\%$/\r/e

" When shortcut files are updated, renew bash and ranger configs with new material:
	autocmd BufWritePost bm-files,bm-dirs !shortcuts
" Run xrdb whenever Xdefaults or Xresources are updated.
	autocmd BufRead,BufNewFile xresources,xdefaults set filetype=xdefaults
	autocmd BufWritePost Xresources,Xdefaults,xresources,xdefaults !xrdb %
" Recompile dwmblocks on config edit.
	autocmd BufWritePost ~/.local/src/dwmblocks/config.h !cd ~/.local/src/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid -f dwmblocks }

" Turns off highlighting on the bits of code that are changed, so the line that is changed is highlighted but the actual text that has changed stands out on the line and is readable.
if &diff
    highlight! link DiffText MatchParen
endif

" Initialize fcitx5state variable
let g:fcitx5state = system("fcitx5-remote")

" Disable the input method when exiting insert mode and save the state
autocmd InsertLeave * :silent let g:fcitx5state = system("fcitx5-remote")[0] | silent call system("fcitx5-remote -c")

" Enable the input method when entering insert mode if it was previously enabled
autocmd InsertEnter * :silent if g:fcitx5state == 2 | call system("fcitx5-remote -o") | endif

"let fcitx5state=system("fcitx5-remote")
"autocmd InsertLeave * :silent let fcitx5state=system("fcitx5-remote")[0] | silent !fcitx5-remote -c " Disable the input method when exiting insert mode and save the state
"autocmd InsertEnter * :silent if fcitx5state == 2 | call system("fcitx5-remote -o") | endif " 2 means that the input method was opened in the previous state, and the input method is started when entering the insert mode


" Function for toggling the bottom statusbar:
"let s:hidden_all = 1
"function! ToggleHiddenAll()
"    if s:hidden_all  == 0
"        let s:hidden_all = 1
"        set noshowmode
"        set noruler
"        set laststatus=0
"        set noshowcmd
"    else
        "let s:hidden_all = 0
        "set showmode
        "set ruler
        "set laststatus=2
        "set showcmd
"    endif
"endfunction
"nnoremap <leader>h :call ToggleHiddenAll()<CR>

"Lualine

lua << END
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,

    globalstatus = false,
    refresh = {
      statusline = 100,
      tabline = 100,
      winbar = 100,

    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },

  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

END


"Basicos que no sé si están repetidos

noremap <Space><Space> <Esc>/(<>)<Enter>c%
inoremap <Space><Space> <C-g>u<Esc>/(<>)<Enter>c%<C-g>u
nnoremap çs :set spell spelllang=es<Enter>
nnoremap çS :set nospell <Enter>
nnoremap çp :silent !zathura *.pdf &<enter>

autocmd FileType tex nnoremap çc :w<cr>:!xelatex -interaction=nonstopmode % <enter>
autocmd FileType tex nnoremap çb :w<CR>:silent !biber --onlylog *.bcf <enter><c-l>
autocmd FileType tex nnoremap çw :w<cr>:!texcount %<enter>

"folds

set foldmethod=manual   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use

augroup remember_folds
	autocmd!
	autocmd BufWinLeave * mkview
	autocmd BufWinEnter * silent! loadview
augroup END


inoremap <F5> <C-R>=strftime("%T")<CR>
inoremap <F6> <C-R>=strftime("%A %d.%m.%Y")<CR>

"LATEX

autocmd FileType tex inoremap <leader>s <C-g>u\section{}<Enter><Enter>(<>)<Esc>?{<Enter>a<C-g>u
autocmd FileType tex inoremap <leader>1s <C-g>u\subsection{}<Enter><Enter>(<>)<Esc>?{<Enter>a<C-g>u
autocmd FileType tex inoremap <leader>2s <C-g>u\subsubsection{}<Enter><Enter>(<>)<Esc>?{<Enter>a<C-g>u
autocmd FileType tex inoremap <leader>R <C-g>u{\scshape }(<>)<Esc>Tea<C-g>u
autocmd FileType tex inoremap <leader>g <C-g>u\textgreek{}(<>)<Esc>T{i<C-g>u
autocmd FileType tex inoremap <leader>it <C-g>u\textit{}(<>)<Esc>T{i<C-g>u
autocmd FileType tex inoremap <leader>bf <C-g>u\textbf{}(<>)<Esc>T{i<C-g>u
autocmd FileType tex inoremap <leader>ca <C-g>u\cite{}(<>)<Esc>T{i<C-g>u
autocmd FileType tex inoremap <leader>ct <C-g>u\textcite[]{.}(<>)<Esc>F.s<C-g>u
autocmd FileType tex inoremap <leader>cpt <C-g>u\textcite[p. ]{(<>)}(<>)<Esc>T.a<C-g>u
autocmd FileType tex inoremap <leader>pc <C-g>u\parencite[p. ]{(<>)}(<>)<Esc>T.a<C-g>u
autocmd FileType tex inoremap <leader>cp <C-g>u\cite[p. ]{(<>)}(<>)<Esc>T.a<C-g>u
autocmd FileType tex inoremap <leader>fc <C-g>u\footcite[p. ]{(<>)}(<>)<Esc>T.a<C-g>u
autocmd FileType tex inoremap <leader>fn <C-g>u\footnote{}(<>)<Esc>T{i<C-g>u
autocmd FileType tex inoremap <leader>ll <C-g>u\begin{enumerate*}[label=--- \arabic*º \enspace] <Enter>\item \textit{.---} (<>) <Enter>\end{enumerate*}<Enter>(<>)<Esc>?.---<Enter>i<C-g>u
autocmd FileType tex inoremap <leader>ln <C-g>u\begin{enumerate}<Enter>\item<Space>loco<Enter>\end{enumerate}<Enter>(<>)<Esc>?loco<Enter>cw<C-g>u
autocmd FileType tex inoremap <leader>lp <C-g>u\begin{itemize}<Enter>\item<Space>loco<Enter>\end{itemize}<Enter>(<>)<Esc>?loco<Enter>cw<C-g>u
autocmd FileType tex inoremap <leader>ni <C-g>u<Esc>A<Enter>\item<Space><C-g>u
autocmd FileType tex inoremap <leader>na <C-g>u\item \textit{.---} (<>) <Esc>T{i<C-g>u
autocmd FileType tex inoremap <leader>q <C-g>u\begin{quotation}<Enter>loco<Enter>\end{quotation}<Enter>(<>)<Esc>?loco<Enter>cw<C-g>u
"autocmd FileType tex inoremap <leader>t \begin{center}<Enter>loco<Enter>\end{center}<Enter>(<>)<Esc>?loco<Enter>cw
autocmd FileType tex inoremap <leader>r <C-g>u\begin{flushright}<Enter>loco<Enter>\end{flushright}<Enter>(<>)<Esc>?loco<Enter>cw<C-g>u
autocmd FileType tex inoremap <leader>l <C-g>u\begin{flushleft}<Enter>loco<Enter>\end{flushleft}<Enter>(<>)<Esc>?loco<Enter>cw<C-g>u
autocmd FileType tex inoremap <leader>ig <C-g>u\includegraphics[]{(<>)}(<>)<Esc>T[i<C-g>u
autocmd FileType tex inoremap <leader>t <C-g>u\begin{center}<Enter>\begin{tblr}{colspec={X[-1]X}}<Enter> (<>)	& (<>) \\<Enter>\hline<Enter>(<>)	& (<>) \\<Enter>\hline<Enter>\end{tblr}<Enter>\end{center}<Esc>?]<Enter>

autocmd FileType tex inoremap <leader>D <C-g>u\begin{frame}<Enter>\frametitle{loco}<Enter>(<>)<Enter>\end{frame}<Enter>(<>)<Esc>?loco<Enter>cw<C-g>u
autocmd FileType tex inoremap <leader>Ce <C-g>u\begin{colums}<Enter>loco<Enter>\end{column}<Esc>?loco<Enter>cw<C-g>u
autocmd FileType tex inoremap <leader>Cc <C-g>u\column{\textwidth}<Enter>(<>)<Esc>k0f{a<C-g>u
autocmd FileType tex inoremap <leader>T <C-g>u\setbeamercovered{}(<>)<Esc>T{i<C-g>u
autocmd FileType tex inoremap <leader>P <C-g>u\pause<C-g>u
autocmd FileType tex inoremap <leader>B <C-g>u\begin{block}{loco}<Enter>(<>)<Enter>\end{block}<Enter>(<>)<Esc>?loco<Enter>cw<C-g>u
autocmd FileType tex inoremap <leader><Enter> <C-g>u\paragraph{} (<>)<Esc>T{i<C-g>u
autocmd FileType tex inoremap <leader>1<Enter> <C-g>u\subparagraph{} (<>)<Esc>T{i<C-g>u

autocmd FileType tex inoremap <leader>N <C-g>u\begin{center}<Enter>\begin{figure}[h]<Enter>\begin{subfigure}{0.5\linewidth}<Enter>\begin{center}<Enter>\begin{prooftree}{to prove={}}<Enter><Tab>[{(<>),<Space>(<>)},<Space>just=Premisa(<>)]<Enter>\end{prooftree}<Enter><Enter>\hfill<Enter><Enter>No se cierra.<Enter><Enter>\end{center}<Enter>\end{subfigure}<Enter>\begin{subfigure}{0.5\linewidth}<Enter>\begin{center}<Enter>Contramodelo(<>):<Enter><Enter>\vspace{0.5cm}<Enter>\begin{tikzpicture}[modal]<Enter>\node[world] (w0) [label=below:$w_0$] {$(<>)$};(<>)<Enter>\end{tikzpicture}<Enter><Enter>$W=\{(<>)\}$<Enter><Enter>$w_(<>)Rw_(<>)$<Enter><Enter>$v_{w_(<>)}((<>))=(<>)$<Enter><Enter>\end{center}<Enter>\end{subfigure}<Enter>\end{figure}<Enter>\end{center}<Enter><Enter>(<>)<Esc>?prove<Enter>f}i<C-g>u
autocmd FileType tex inoremap <leader>nn <C-g>u<Enter>[{, (<>)}, just={(<>)$(<>)$(<>)}(<>)]<Esc>2T{i<C-g>u
autocmd FileType tex inoremap <leader>n2 <C-g>u<Enter><Tab>[{, (<>)}][{(<>), (<>)}, just={(<>)$(<>)$(<>)}(<>)]<Esc>3T{i<C-g>u
autocmd FileType tex inoremap <leader>nw <C-g>u<Enter>\node[world] (w(<>)) [label=below:$w_(<>)$, right of=w(<>)] {$(<>)$};(<>)<Esc>5Fwi<C-g>u
autocmd FileType tex inoremap <leader>np <C-g>u<Enter>\path[->] (w(<>)) edge[] (w(<>));(<>)<Esc>F-i<C-g>u
" autocmd FileType tex inoremap <leader>t <C-g>u\begin{theorem}<Enter>loco<Enter>\end{theorem}<Enter>(<>)<Esc>?loco<Enter>cw<C-g>u
autocmd FileType tex inoremap <leader>d <C-g>u\begin{proof}<Enter>loco<Enter>\end{proof}<Enter>(<>)<Esc>?loco<Enter>cw<C-g>u
autocmd FileType tex inoremap <leader>L <C-g>u\begin{lemma}<Enter>loco<Enter>\end{lemma}<Enter>(<>)<Esc>?loco<Enter>cw<C-g>u
autocmd FileType tex inoremap -> <C-g>u$\rightarrow$<C-g>u

autocmd FileType bib inoremap <leader>a <C-g>u@article{loco,<Enter>author = {(<>)},<Enter>title = {(<>)},<Enter>publisher = {(<>)},<Enter>address = {(<>)},<Enter>year = {(<>)},<Enter>journal = {(<>)},<Enter>volume = {(<>)},<Enter>number = {(<>)},<Enter>month = {(<>)},<Enter>pages = {(<>)},<Enter>doi = {(<>)},<Enter>url = {(<>)},}<Enter>(<>)<Esc>?loco<Enter>cw<C-g>u
autocmd FileType bib inoremap <leader>b <C-g>u@book{loco,<Enter>author = {(<>)},<Enter>title = {(<>)},<Enter>subtitle = {(<>)},<Enter>publisher = {(<>)},<Enter>address = {(<>)},<Enter>date = {(<>)},<Enter>series = {(<>)},<Enter>origtitle = {(<>)},<Enter>origdate = {(<>)},<Enter>isbn = {(<>)},<Enter>edition = {(<>)},<Enter>volume = {(<>)},<Enter>editor = {(<>)},<Enter>}<Enter>(<>)<Esc>?loco<Enter>cw<C-g>u
autocmd FileType bib inoremap <leader>m <C-g>u@mvbook{loco,<Enter>author = {(<>)},<Enter>editor = {(<>)},<Enter>title = {(<>)},<Enter>publisher = {(<>)},<Enter>address = {(<>)},<Enter>date = {(<>)},<Enter>series = {(<>)},<Enter>origdate = {(<>)},<Enter>isbn = {(<>)},<Enter>edition = {(<>)},<Enter>volumes = {(<>)},<Enter>}<Enter>(<>)<Esc>?loco<Enter>cw<C-g>u
autocmd FileType bib inoremap <leader>c <C-g>u@collection{loco,<Enter>editor = {(<>)},<Enter>title = {(<>)},<Enter>publisher = {(<>)},<Enter>address = {(<>)},<Enter>date = {(<>)},<Enter>series = {(<>)},<Enter>isbn = {(<>)},<Enter>edition = {(<>)},<Enter>volumes = {(<>)},<Enter>}<Enter>(<>)<Esc>?loco<Enter>cw<C-g>u
autocmd FileType bib inoremap <leader>ic <C-g>u@incollection{loco,<Enter>author = {(<>)},<Enter>title = {(<>)},<Enter>date = {(<>)},<Enter>crossref = {(<>)},<Enter>pages = {(<>)},<Enter>translator = {(<>)},<Enter>}<Enter>(<>)<Esc>?loco<Enter>cw<C-g>u
autocmd FileType bib inoremap <leader>ib <C-g>u@inbook{loco,<Enter>author = {(<>)},<Enter>title = {(<>)},<Enter>crossref = {(<>)},<Enter>date = {(<>)},<Enter>}<Enter>(<>)<Esc>?loco<Enter>cw<C-g>u
autocmd FileType bib inoremap <leader>im <C-g>u@bookinbook{loco,<Enter>author = {(<>)},<Enter>title = {(<>)},<Enter>date = {(<>)},<Enter>volume = {(<>)},<Enter>editor = {(<>)},<Enter>translator = {(<>)},<Enter>crossref = {(<>)},<Enter>}<Enter>(<>)<Esc>?loco<Enter>cw<C-g>u

"HTML

"autocmd FileType html nnoremap çp :silent !firefox % &<enter><c-l> creo que ya no hace falta

autocmd FileType html inoremap <leader>1 <h1>ye</h1><Enter>(<>)<Esc>?ye<Enter>cw
autocmd FileType html inoremap <leader>2 <h2>ye</h2><Enter>(<>)<Esc>?ye<Enter>cw
autocmd FileType html inoremap <leader>3 <h3>ye</h3><Enter>(<>)<Esc>?ye<Enter>cw
autocmd FileType html inoremap <leader>4 <h4>ye</h4><Enter>(<>)<Esc>?ye<Enter>cw
autocmd FileType html inoremap <leader>5 <h5>ye</h5><Enter>(<>)<Esc>?ye<Enter>cw
autocmd FileType html inoremap <leader>6 <h6>ye</h6><Enter>(<>)<Esc>?ye<Enter>cw
autocmd FileType html inoremap <leader>p <p>ye</p><Enter>(<>)<Esc>?ye<Enter>cw
autocmd FileType html inoremap <leader>r <a href="ye">(<>)</a>(<>)<Esc>?ye<Enter>cw
autocmd FileType html inoremap <leader>i  <img src="ye" alt="(<>)" width="(<>)" height="(<>)"> (<>)<Esc>?ye<Enter>cw
autocmd FileType html inoremap <leader>b  <button>ye</button> (<>)<Esc>?ye<Enter>cw
autocmd FileType html inoremap <leader>ul <ul><Enter><Tab><li>ye</li><Enter></ul><Enter>(<>)<Esc>?ye<Enter>cw
autocmd FileType html inoremap <leader>ol <ol><Enter><Tab><li>ye</li><Enter></ol><Enter>(<>)<Esc>?ye<Enter>cw
autocmd FileType html inoremap <leader>ni <Esc>A<Enter><li>ye</li><Esc>?ye<Enter>cw
autocmd FileType html inoremap <leader>s <strong>ye</strong>(<>)<Esc>?ye<Enter>cw
autocmd FileType html inoremap <leader>e <em>ye</em>(<>)<Esc>?ye<Enter>cw
autocmd FileType html inoremap <leader>N1 <sup id="1^"><a href="#1">1</a></sup>(<>)<Esc>Go<p class="sm">&#8212;&#8212;</p><Enter><p class="nt" id="1">[1] <a href="#1^">^</a></p><Esc>T]a
autocmd FileType html inoremap <leader>n1 <sup id="1^"><a href="#1">1</a></sup>(<>)<Esc>?</body><Enter>O<p class="sm">&#8212;&#8212;</p><Enter><p class="nt" id="1">[1] <a href="#1^">^</a></p><Esc>T]a
autocmd FileType html inoremap <leader>n2 <sup id="2^"><a href="#2">2</a></sup>(<>)<Esc>?</body><Enter>O<p class="sm">&#8212;&#8212;</p><Enter><p class="nt" id="2">[2] <a href="#2^">^</a></p><Esc>T]a

"Lilypond raro

"/usr/share/vim/vimfiles/ftplugin/lilypond.vim es un plugin con más atajos
"autocmd FileType ly
nnoremap çl :w<cr>:!lilypond -l=NONE % >/dev/null<enter>:redraw<enter>
inoremap <leader>32 \tuplet<Space>3/2<Space>2<Space>{}<Space>(<>)<Esc>T{i
inoremap <leader>34 \tuplet<Space>3/2<Space>4<Space>{}<Space>(<>)<Esc>T{i
nnoremap ºº i<Space>--<Space><Esc>l
nnoremap º1 r_
