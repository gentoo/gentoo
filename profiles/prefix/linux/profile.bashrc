# Copyright 2011-2016 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This is a ugly issue, see bug 289757 for origins
# This mimics the check in gcc ebuilds, bug 362315
#
# # Remember, bash treats floats like strings..

get_libc_vers_min() {
	if [[ -x /usr/bin/ldd ]] ; then
		/usr/bin/ldd --version \
			| head -n1 \
			| grep -o ") 2\.[0-9]\+" \
			| cut -d. -f2
		return
	elif [[ -x /lib/libc.so.6 || -x /lib64/libc.so.6 ]] ; then
		{
			/lib/libc.so.6 || /lib64/libc.so.6
		} 2>/dev/null \
			| head -n1 \
			| grep -o 'version 2\.[0-9]\+' \
			| cut -d. -f2
		return
	fi
	echo "0"
}

if [[ ${CATEGORY}/${PN} == sys-devel/gcc && ${EBUILD_PHASE} == unpack ]]; then
    # Since 2.3 > 2.12 in numerical terms, just compare 2.X to 2.Y, will break
    # if >=3.0 is ever released
    VERS=$(get_libc_vers_min)
    if [[ $VERS -lt 12 ]]; then # compare host glibc 2.x to 2.12
        ewarn "Your host glibc is too old; disabling automatic fortify. bug 289757"
        EPATCH_EXCLUDE+=" 10_all_gcc-default-fortify-source.patch" # <=gcc-4.5*
        EPATCH_EXCLUDE+=" 10_all_default-fortify-source.patch" # >=gcc-4.6*
    fi
fi

if [[ ${EBUILD_PHASE} == setup ]]; then
    VERS=$(get_libc_vers_min)
    if [[ $VERS -lt 6 && "${CFLAGS} " != *'gnu89-inline '* ]]; then # compare host glibc 2.x to 2.6
        einfo "Your host glibc is too old; enabling -fgnu89-inline compiler flag. bug 473524"
        CFLAGS="${CFLAGS} -fgnu89-inline" # for C only
    fi  
fi

# vim: set syn=sh:
