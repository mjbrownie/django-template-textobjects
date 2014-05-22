" textobj-django_template - Text objects for django templates
" Version: 0.2.0
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
" Dependencies:
"
"     textobj-user by Kana Natsuno
"     http://www.vim.org/scripts/script.php?script_id=2100
"
" Overview:
"     This plugin adds some textobjects to the htmldjango filetype
"
"     idb/adb - in/around a django {% block %}
"     idf/adf - in around a django {% for %} loop
"     idi/adi - in/around a django {% if* } tag
"     idw/adw - in around a django {% with %} tag
"
"    so Use as you would other text objects in visual selection, cutting and
"    dealleting etc.
"
" Installation:
"
"   Please ensure you have the above plugins installed as instructed
"   This file should be in your after/ftplugin for htmldjango
"
"   ~/.vim/after/ftplugin/htmldjango/template_textobjects.vim
"
" }}

"TODO This if block is vestigial from when matchit.vim was required. It still
"performs a useful setup but should probably be in the syntax file.
if exists("loaded_matchit")
    let b:match_ignorecase = 1
    let b:match_skip = 's:Comment'
    let b:match_words = '<:>,' .
    \ '<\@<=[ou]l\>[^>]*\%(>\|$\):<\@<=li\>:<\@<=/[ou]l>,' .
    \ '<\@<=dl\>[^>]*\%(>\|$\):<\@<=d[td]\>:<\@<=/dl>,' .
    \ '<\@<=\([^/][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>,'  .
    \ '{% *if .*%}:{% *else *%}:{% *elif .*%}:{% *endif *%},' .
    \ '{% *ifequal .*%}:{% *else *%}:{% *endifequal *%},' .
    \ '{% *ifnotequal .*%}:{% *else *%}:{% *endifnotequal *%},' .
    \ '{% *ifchanged .*%}:{% *else *%}:{% *endifchanged *%},' .
    \ '{% *for .*%}:{% *endfor *%},' .
    \ '{% *with .*%}:{% *endwith *%},' .
    \ '{% *comment .*%}:{% *endcomment *%},' .
    \ '{% *block .*%}:{% *endblock *%},' .
    \ '{% *filter .*%}:{% *endfilter *%},' .
    \ '{% *spaceless .*%}:{% *endspaceless *%},' .
    \ '{% *cache .*%}:{% *endcache *%}' .
    \ '{% *blocktrans .*%}:{% *endblocktrans *%}'
endif

if !exists('*s:select_a')

    fun s:select_a(type)
        let initpos = getpos(".")

        let e =searchpairpos('{% *'.a:type.' .*%}','','{% *end'.a:type. ' *%}','b')
        if  ( e == [0,0])
            return 0
        endif

        let e = [bufnr("%")] + e + [0]

        call setpos(".",initpos)

        call searchpair('{% *'.a:type.' .*%}','','{% *end'.a:type. ' *%}','')

        norm f}
        let b =  getpos(".")

        return ['v',b,e]
    endfun

    fun s:select_i(type)
        let initpos = getpos(".")
        if  (searchpair('{% *'.a:type.' .*%}','','{% *end'.a:type. ' *%}','b') == 0)
            return 0
        endif

        normal f}
        "move one pesky char
        call search('.')
        let e =getpos('.')

        call setpos(".",initpos)

        call searchpair('{% *'.a:type.' .*%}','','{% *end'.a:type. ' *%}','')
"        call search(".", 'b')
        let b = getpos(".")

        "move one pesky char
        call search('.','b')
        let b = getpos('.')
        return ['v',b,e]
    endfun

    fun s:select_block_a()
       return  s:select_a('block')
    endfun

    fun s:select_if_a()
       return s:select_a('if\(equal\|notequal\|changed\|\)')
    endfun

    fun s:select_with_a()
       return s:select_a('with')
    endfun

    fun s:select_comment_a()
       return s:select_a('comment')
    endfun


    fun s:select_for_a()
       return s:select_a('for')
    endfun

    fun s:select_block_i()
       return s:select_i('block')
    endfun

    fun s:select_if_i()
       return s:select_i('if\(equal\|notequal\|changed\|\)')
    endfun

    fun s:select_with_i()
       return s:select_i('with')
    endfun

    fun s:select_comment_i()
       return s:select_i('comment')
    endfun

    fun s:select_for_i()
       return s:select_i('for')
    endfun


    fun s:select_autoescape_a()
       return s:select_a('autoescape')
    endfun

    fun s:select_autoescape_i()
       return s:select_i('autoescape')
    endfun

    fun s:select_filter_a()
       return s:select_a('filter')
    endfun

    fun s:select_filter_i()
       return s:select_i('filter')
    endfun

    fun s:select_spaceless_a()
       return s:select_a('spaceless')
    endfun

    fun s:select_spaceless_i()
       return s:select_i('spaceless')
    endfun

    fun s:select_cache_a()
       return s:select_a('cache')
    endfun

    fun s:select_cache_i()
       return s:select_i('cache')
    endfun

    fun s:select_blocktrans_a()
       return s:select_a('blocktrans')
    endfun

    fun s:select_blocktrans_i()
       return s:select_i('blocktrans')
    endfun

    fun s:select_variable_i()
        let initpos = getpos(".")
        if  (searchpair('{{.','','}}','b') == 0)
            return 0
        endif

        call search('..')
        let e = getpos('.')
        call search('.}}')
        let b = getpos('.')
        return ['v',b,e]
    endfun

    fun s:select_variable_a()
        let initpos = getpos(".")
        if  (searchpair('{{','','}}','b') == 0)
            return 0
        endif
        let b = getpos('.')
        call search('}}','e')
        let e = getpos('.')
        return ['v',b,e]
    endfun

    fun s:select_tag_i()
        let initpos = getpos(".")
        if  (searchpair('{%.','','%}','b') == 0)
            return 0
        endif

        call search('..')
        let e = getpos('.')
        call search('.%}')
        let b = getpos('.')
        return ['v',b,e]
    endfun

    fun s:select_tag_a()
        let initpos = getpos(".")
        if  (searchpair('{%','','%}','b') == 0)
            return 0
        endif
        let b = getpos('.')
        call search('%}','e')
        let e = getpos('.')
        return ['v',b,e]
    endfun
endif

call textobj#user#plugin('djangotemplate',{
\   'block':{
\       '*sfile*': expand('<sfile>:p'),
\       'select-a':'adb','*select-a-function*':'s:select_block_a',
\       'select-i':'idb', '*select-i-function*':'s:select_block_i'
\   },
\   'if':{
\       '*sfile*': expand('<sfile>:p'),
\       'select-a':'adi','*select-a-function*':'s:select_if_a',
\       'select-i':'idi', '*select-i-function*':'s:select_if_i'
\   },
\   'with':{
\       '*sfile*': expand('<sfile>:p'),
\       'select-a':'adw','*select-a-function*':'s:select_with_a',
\       'select-i':'idw', '*select-i-function*':'s:select_with_i'
\   },
\   'comment':{
\       '*sfile*': expand('<sfile>:p'),
\       'select-a':'adc','*select-a-function*':'s:select_comment_a',
\       'select-i':'idc', '*select-i-function*':'s:select_comment_i'
\   },
\   'for':{
\       '*sfile*': expand('<sfile>:p'),
\       'select-a':'adf','*select-a-function*':'s:select_for_a',
\       'select-i':'idf', '*select-i-function*':'s:select_for_i'
\   },
\   'autoescape':{
\       '*sfile*': expand('<sfile>:p'),
\       'select-a':'ada','*select-a-function*':'s:select_autoescape_a',
\       'select-i':'ida', '*select-i-function*':'s:select_autoescape_i'
\   },
\   'spaceless':{
\       '*sfile*': expand('<sfile>:p'),
\       'select-a':'ads','*select-a-function*':'s:select_spaceless_a',
\       'select-i':'ids', '*select-i-function*':'s:select_spaceless_i'
\   },
\   'filter':{
\       '*sfile*': expand('<sfile>:p'),
\       'select-a':'ads','*select-a-function*':'s:select_filter_a',
\       'select-i':'ids', '*select-i-function*':'s:select_filter_i'
\   },
\   'cache':{
\       '*sfile*': expand('<sfile>:p'),
\       'select-a':'adC','*select-a-function*':'s:select_cache_a',
\       'select-i':'idC', '*select-i-function*':'s:select_cache_i'
\   },
\   'blocktrans':{
\       '*sfile*': expand('<sfile>:p'),
\       'select-a':'adT','*select-a-function*':'s:select_blocktrans_a',
\       'select-i':'idT', '*select-i-function*':'s:select_blocktrans_i'
\   },
\   'variable':{
\       '*sfile*': expand('<sfile>:p'),
\       'select-a':'adv','*select-a-function*':'s:select_variable_a',
\       'select-i':'idv', '*select-i-function*':'s:select_variable_i'
\   },
\   'tag':{
\       '*sfile*': expand('<sfile>:p'),
\       'select-a':'adt','*select-a-function*':'s:select_tag_a',
\       'select-i':'idt', '*select-i-function*':'s:select_tag_i'
\   },
\})

runtime! after/ftplugin/html/html_textobjects.vim
