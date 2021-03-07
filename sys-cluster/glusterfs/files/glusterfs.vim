if &compatible || v:version < 603
    finish
endif


" GlusterFS Volume files
au BufNewFile,BufRead *.vol
    \     set filetype=glusterfs
