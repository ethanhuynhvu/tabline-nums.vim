function! Tabline()
    let tablinestr = ''
    let winwidth = &columns
    let tabscount = tabpagenr('$')
    let i = 0
    for tablabel in AbbrvTabLabels(TabLabels(), winwidth - 1)
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

function! AbbrvTabLabels(tablabels, maxchars)
    let labelschars = 0
    for label in a:tablabels
        let labelschars += strchars(label)
    endfor
    if labelschars > a:maxchars
        let maxlabelchars = a:maxchars / len(a:tablabels)
        let abbrvtablabels = []
        for label in a:tablabels
            let labelchars = strchars(label)
            let abbrvlabel = label[:maxlabelchars - 2] . ' '
            call add(abbrvtablabels, abbrvlabel)
        endfor
        return abbrvtablabels
    endif
    return a:tablabels
endfunction

function! TabLabel(tabnr)
    let label = ' '
    let label .= a:tabnr . ' '
    let wincountandbufmod = ''
    let wincount = tabpagewinnr(a:tabnr, '$')
    if wincount > 1
        let wincountandbufmod .= wincount
    endif
    if ContainsBufMod(a:tabnr)
        let wincountandbufmod .= '+'
    endif
    if wincountandbufmod != ''
        let label .= wincountandbufmod . ' '
    endif
    let label .= FileName(a:tabnr)
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
