# RAP specific patches that is pending upstream.
# binutils: http://article.gmane.org/gmane.comp.gnu.binutils/67593

if [[ ${CATEGORY}/${PN} == sys-devel/gcc && ${EBUILD_PHASE} == prepare ]]; then
    cd "${S}"
    einfo "Prefixifying glibc dynamic linker..."
    for h in gcc/config/*/linux*.h; do
	ebegin "  Updating $h"
	sed -i -r "s,(GLIBC_DYNAMIC_LINKER.*\")(/lib),\1${EPREFIX}\2," \
	    $h || eerror "Please file a bug about this"
	eend $?
    done

    # use sysroot of toolchain to get currect include and library at compile time
    EXTRA_ECONF="${EXTRA_ECONF} --with-sysroot=${EPREFIX}"

    ebegin "remove --sysroot call on ld for native toolchain"
    sed -i 's/--sysroot=%R//' \
	gcc/gcc.c || eerror "Please file a bug about this"
    eend $?
fi

if [[ ${CATEGORY}/${PN} == sys-devel/binutils && ${EBUILD_PHASE} == prepare ]]; then
    cd "${S}"
    ebegin "Prefixifying native library path"
    sed -i -r "/NATIVE_LIB_DIRS/s,((/usr(/local|)|)/lib),${EPREFIX}\1,g" \
	ld/configure.tgt || eerror "Please file a bug about this"
    eend $?
fi
