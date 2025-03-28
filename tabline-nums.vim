function! Tabline()
    let tablinestr = ''
    let winwidth = winwidth(0)
    let tabscount = tabpagenr('$')
    let i = 0
    for tablabel in TabLabels()
        if i + 1 == tabpagenr()
            let tablinestr .= '%#TabLineSel#'
        else
            let tablinestr .= '%#TabLine#'
        endif
        let tablinestr .= '%' . (i + 1) . 'T'
        let tablinestr .= tablabel
    endfor
    let tablinestr .= '%#TabLineFill#%T'
    if tabscount > 1
        let tablinestr .= '%=%#TabLine#%' . winwidth . 'XX'
    endif
    return tablinestr
endfunction

function! TabLabels()
    let labels = []
    for i in range(tabpagenr('$'))
        call add(labels, TabLabel(i + 1))
    endfor
    return labels
endfunction

function! TabLabel(tabnr)
    let label = ' '
    let label .= a:tabnr . ' '
    let wincount = tabpagewinnr(a:tabnr, '$')
    if wincount > 1
        let label .= wincount
    endif
    if ContainsBufMod(a:tabnr)
        let label .= '+'
    endif
    let label .= ' ' . FileName(a:tabnr)
    let label .= ' '
    return label
endfunction

function! FileName(tabnr)
    let buflist = tabpagebuflist(a:tabnr)
    let winnr = tabpagewinnr(a:tabnr)
    return fnamemodify(bufname(buflist[winnr - 1]), ':t')
endfunction

function! ContainsBufMod(tabnr)
    let containsmod = 0
    let buflist = tabpagebuflist(a:tabnr)
    for bufnr in buflist
        let containsmod += getbufvar(bufnr, '&mod')
    endfor
    return containsmod
endfunction

set tabline=%!TabLine()
