#!/usr/bin/awk -f

{
    GENTOO_ENABLE=1;
    if (match($0, /flags="([^"=]*)"/, cflags)) {
        split(cflags[1], fields);
        for (i in fields) {
            if (match(fields[i], /-m([[:graph:]]*)/, inst)) {
                if (!index(enabled_flags, inst[1])) {
                    GENTOO_ENABLE=0;
                }}}}
    if (!GENTOO_ENABLE) { sub(cflags[1], "-mGENTOO_DISABLE"); }
    print; 
}
