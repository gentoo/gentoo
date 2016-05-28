# -*- mode: shell-script; -*-
# RAP specific patches that is pending upstream.
# binutils: http://article.gmane.org/gmane.comp.gnu.binutils/67593

# Disable RAP trick during bootstrap stage2
[[ -z ${BOOTSTRAP_RAP_STAGE2} ]] || return 0

if [[ ${CATEGORY}/${PN} == sys-devel/gcc && ${EBUILD_PHASE} == configure ]]; then
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
elif [[ ${CATEGORY}/${PN} == sys-devel/binutils && ${EBUILD_PHASE} == prepare ]]; then
    cd "${S}"
    ebegin "Prefixifying native library path"
    sed -i -r "/NATIVE_LIB_DIRS/s,((/usr(/local|)|)/lib),${EPREFIX}\1,g" \
	ld/configure.tgt || eerror "Please file a bug about this"
    eend $?
elif [[ ${CATEGORY}/${PN} == sys-libs/glibc && ${EBUILD_PHASE} == configure ]]; then
    cd "${S}"
    einfo "Prefixifying hardcoded path"
    
    for f in libio/iopopen.c \
		 shadow/lckpwdf.c resolv/{netdb,resolv}.h elf/rtld.c \
		 nis/nss_compat/compat-{grp,initgroups,{,s}pwd}.c \
		 nss/{bug-erange,nss_files/files-init{,groups}}.c \
		 sysdeps/{{generic,unix/sysv/linux}/paths.h,posix/system.c}
    do
	ebegin "  Updating $f"
	sed -i -r \
	    -e "s,([:\"])/(etc|usr|bin|var),\1${EPREFIX}/\2,g" \
	    $f || eerror "Please file a bug about this"
	eend $?
    done
    ebegin "  Updating nss/db-Makefile"
    sed -i -r \
	-e "s,/(etc|var),${EPREFIX}/\1,g" \
	nss/db-Makefile || eerror "Please file a bug about this"
    eend $?
elif [[ ${CATEGORY}/${PN} == dev-lang/python && ${EBUILD_PHASE} == configure ]]; then
    # Guide h2py to look into glibc of Prefix
    ebegin "Guide h2py to look into Prefix"
    export include="${EPREFIX}"/usr/include
    sed -i -r \
	-e "s,/usr/include,\"${EPREFIX}\"/usr/include,g" "${S}"/Lib/plat-linux*/regen
    eend $?
fi
