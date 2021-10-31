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
Plug 'junegunn/goyo.vim'
Plug 'jreybert/vimagit'
Plug 'lukesmithxyz/vimling'
Plug 'vimwiki/vimwiki'
Plug 'bling/vim-airline'
Plug 'tpope/vim-commentary'
Plug 'ap/vim-css-color'
call plug#end()

set title
set bg=light
set go=a
set mouse=a
set nohlsearch
set clipboard+=unnamedplus
set noshowmode
set noruler
set laststatus=0
set noshowcmd
set viminfofile=$XDG_CACHE_HOME/vim/viminfo

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
" Spell-check set to <leader>o, 'o' for 'orthography':
	map <leader>o :setlocal spell! spelllang=es_ES<CR>
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
	autocmd BufRead,BufNewFile *.tex set filetype=tex

" Save file as sudo on files that require root permission
	cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Enable Goyo by default for mutt writing
	autocmd BufRead,BufNewFile /tmp/neomutt* let g:goyo_width=80
	autocmd BufRead,BufNewFile /tmp/neomutt* :Goyo | set bg=light
	autocmd BufRead,BufNewFile /tmp/neomutt* map ZZ :Goyo\|x!<CR>
	autocmd BufRead,BufNewFile /tmp/neomutt* map ZQ :Goyo\|q!<CR>

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

" Function for toggling the bottom statusbar:
let s:hidden_all = 1
function! ToggleHiddenAll()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2
        set showcmd
    endif
endfunction
nnoremap <leader>h :call ToggleHiddenAll()<CR>

"Basicos que no sé si están repetidos

noremap <Space><Space> <Esc>/(<>)<Enter>c%
inoremap <Space><Space> <Esc>/(<>)<Enter>c%
nnoremap çs :set spell spelllang=es<Enter>
nnoremap çS :set nospell <Enter>
nnoremap çp :silent !zathura *.pdf &<enter>

autocmd FileType tex nnoremap çc :w<cr>:!pdflatex -interaction=nonstopmode % >/dev/null<enter>:redraw<enter>
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

"LATEX

autocmd FileType tex inoremap <leader>s \section{}(<>)<Esc>T{i
autocmd FileType tex inoremap <leader>1s \subsection{}(<>)<Esc>T{i
autocmd FileType tex inoremap <leader>2s \subsubsection{}(<>)<Esc>T{i
autocmd FileType tex inoremap <leader>3s \subsubsubsection{}(<>)<Esc>T{i
autocmd FileType tex inoremap <leader>it \textit{}(<>)<Esc>T{i
autocmd FileType tex inoremap <leader>bf \textbf{}(<>)<Esc>T{i
autocmd FileType tex inoremap <leader>ca \cite{}(<>)<Esc>T{i
autocmd FileType tex inoremap <leader>ct \textcite[p. ]{(<>)}(<>)<Esc>T.a
autocmd FileType tex inoremap <leader>pc \parencite[p. ]{(<>)}(<>)<Esc>T.a
autocmd FileType tex inoremap <leader>cp \cite[p. ]{(<>)}(<>)<Esc>T.a
autocmd FileType tex inoremap <leader>fc \footcite[p. ]{(<>)}(<>)<Esc>T.a
autocmd FileType tex inoremap <leader>fn \footnote{}(<>)<Esc>T{i
autocmd FileType tex inoremap <leader>ln \begin{enumerate}<Enter>\item<Space>loco<Enter>\end{enumerate}<Enter>(<>)<Esc>?loco<Enter>cw
autocmd FileType tex inoremap <leader>lp \begin{itemize}<Enter>\item<Space>loco<Enter>\end{itemize}<Enter>(<>)<Esc>?loco<Enter>cw
autocmd FileType tex inoremap <leader>ni <Enter>\item<Space>
autocmd FileType tex inoremap <leader>q \begin{quotation}<Enter>loco<Enter>\end{quotation}<Enter>(<>)<Esc>?loco<Enter>cw
"autocmd FileType tex inoremap <leader>t \begin{center}<Enter>loco<Enter>\end{center}<Enter>(<>)<Esc>?loco<Enter>cw
autocmd FileType tex inoremap <leader>r \begin{flushright}<Enter>loco<Enter>\end{flushright}<Enter>(<>)<Esc>?loco<Enter>cw
autocmd FileType tex inoremap <leader>l \begin{flushleft}<Enter>loco<Enter>\end{flushleft}<Enter>(<>)<Esc>?loco<Enter>cw
autocmd FileType tex inoremap <leader>ig \includegraphics[]{(<>)}(<>)<Esc>T[i

autocmd FileType tex inoremap <leader>D \begin{frame}<Enter>\frametitle{loco}<Enter>(<>)<Enter>\end{frame}<Enter>(<>)<Esc>?loco<Enter>cw
autocmd FileType tex inoremap <leader>Ce \begin{colums}<Enter>loco<Enter>\end{column}<Esc>?loco<Enter>cw
autocmd FileType tex inoremap <leader>Cc \column{\textwidth}<Enter>(<>)<Esc>k0f{a
autocmd FileType tex inoremap <leader>T \setbeamercovered{}(<>)<Esc>T{i
autocmd FileType tex inoremap <leader>P \pause
autocmd FileType tex inoremap <leader>B \begin{block}{loco}<Enter>(<>)<Enter>\end{block}<Enter>(<>)<Esc>?loco<Enter>cw

autocmd FileType tex inoremap <leader>N \begin{center}<Enter>\begin{figure}[h]<Enter>\begin{subfigure}{0.5\linewidth}<Enter>\begin{center}<Enter>\begin{prooftree}{to prove={}}<Enter><Tab>[{(<>),<Space>(<>)},<Space>just=Premisa(<>)]<Enter>\end{prooftree}<Enter><Enter>\hfill<Enter><Enter>No se cierra.<Enter><Enter>\end{center}<Enter>\end{subfigure}<Enter>\begin{subfigure}{0.5\linewidth}<Enter>\begin{center}<Enter>Contramodelo(<>):<Enter><Enter>\vspace{0.5cm}<Enter>\begin{tikzpicture}[modal]<Enter>\node[world] (w0) [label=below:$w_0$] {$(<>)$};(<>)<Enter>\end{tikzpicture}<Enter><Enter>$W=\{(<>)\}$<Enter><Enter>$w_(<>)Rw_(<>)$<Enter><Enter>$v_{w_(<>)}((<>))=(<>)$<Enter><Enter>\end{center}<Enter>\end{subfigure}<Enter>\end{figure}<Enter>\end{center}<Enter><Enter>(<>)<Esc>?prove<Enter>f}i
autocmd FileType tex inoremap <leader>nn <Enter>[{, (<>)}, just={(<>)$(<>)$(<>)}(<>)]<Esc>2T{i
autocmd FileType tex inoremap <leader>n2 <Enter><Tab>[{, (<>)}][{(<>), (<>)}, just={(<>)$(<>)$(<>)}(<>)]<Esc>3T{i
autocmd FileType tex inoremap <leader>nw <Enter>\node[world] (w(<>)) [label=below:$w_(<>)$, right of=w(<>)] {$(<>)$};(<>)<Esc>5Fwi
autocmd FileType tex inoremap <leader>np <Enter>\path[->] (w(<>)) edge[] (w(<>));(<>)<Esc>F-i
autocmd FileType tex inoremap <leader>t \begin{theorem}<Enter>loco<Enter>\end{theorem}<Enter>(<>)<Esc>?loco<Enter>cw
autocmd FileType tex inoremap <leader>d \begin{proof}<Enter>loco<Enter>\end{proof}<Enter>(<>)<Esc>?loco<Enter>cw
autocmd FileType tex inoremap <leader>L \begin{lemma}<Enter>loco<Enter>\end{lemma}<Enter>(<>)<Esc>?loco<Enter>cw


"HTML

"autocmd FileType html nnoremap çp :silent !firefox % &<enter><c-l> creo que ya no hace falta

autocmd FileType html inoremap <leader>1 <h1>ye</h1><Enter>(<>)<Esc>?ye<Enter>cw
autocmd FileType html inoremap <leader>2 <h2>ye</h2><Enter>(<>)<Esc>?ye<Enter>cw
autocmd FileType html inoremap <leader>3 <h3>ye</h3><Enter>(<>)<Esc>?ye<Enter>cw
autocmd FileType html inoremap <leader>4 <h4>ye</h4><Enter>(<>)<Esc>?ye<Enter>cw
autocmd FileType html inoremap <leader>5 <h5>ye</h5><Enter>(<>)<Esc>?ye<Enter>cw
autocmd FileType html inoremap <leader>6 <h6>ye</h6><Enter>(<>)<Esc>?ye<Enter>cw
autocmd FileType html inoremap <leader>p <p>ye</p><Enter>(<>)<Esc>?ye<Enter>cw
autocmd FileType html inoremap <leader>r <a href="ye">(<>)</a> (<>)<Esc>?ye<Enter>cw
autocmd FileType html inoremap <leader>i  <img src="ye" alt="(<>)" width="(<>)" height="(<>)"> (<>)<Esc>?ye<Enter>cw
autocmd FileType html inoremap <leader>b  <button>ye</button> (<>)<Esc>?ye<Enter>cw
autocmd FileType html inoremap <leader>ul <ul><Enter><Tab><li>ye</li><Enter></ul><Enter>(<>)<Esc>?ye<Enter>cw
autocmd FileType html inoremap <leader>ol <ol><Enter><Tab><li>ye</li><Enter></ol><Enter>(<>)<Esc>?ye<Enter>cw
autocmd FileType html inoremap <leader>ni <Esc>A<Enter><li>ye</li><Esc>?ye<Enter>cw
autocmd FileType html inoremap <leader>s <strong>ye</strong>(<>)<Esc>?ye<Enter>cw
autocmd FileType html inoremap <leader>e <em>ye</ye>(<>)<Esc>?ye<Enter>cw
autocmd FileType html inoremap <leader>N1 <sup id="1^"><a href="#1">1</a></sup>(<>)<Esc>Go<p class="sm">&#8212;&#8212;</p><Enter><p class="nt" id="1">[1] <a href="#1^">^</a></p><Esc>T]a
autocmd FileType html inoremap <leader>n1 <sup id="1^"><a href="#1">1</a></sup>(<>)<Esc>?</body><Enter>O<p class="sm">&#8212;&#8212;</p><Enter><p class="nt" id="1">[1] <a href="#1^">^</a></p><Esc>T]a
autocmd FileType html inoremap <leader>n2 <sup id="1^"><a href="#1">1</a></sup>(<>)<Esc>?</body><Enter>O<p class="sm">&#8212;&#8212;</p><Enter><p class="nt" id="1">[1] <a href="#1^">^</a></p><Esc>T]a

"Lilypond raro

"/usr/share/vim/vimfiles/ftplugin/lilypond.vim es un plugin con más atajos
"autocmd FileType ly
nnoremap çl :w<cr>:!lilypond -l=NONE % >/dev/null<enter>:redraw<enter>
inoremap <leader>32 \tuplet<Space>3/2<Space>2<Space>{}<Space>(<>)<Esc>T{i
inoremap <leader>34 \tuplet<Space>3/2<Space>4<Space>{}<Space>(<>)<Esc>T{i
nnoremap ºº i<Space>--<Space><Esc>l
