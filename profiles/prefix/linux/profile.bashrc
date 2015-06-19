# This is a ugly issue, see bug 289757 for origins
# This mimics the check in gcc ebuilds, bug 362315
#
# # Remember, bash treats floats like strings..

if [[ ${CATEGORY}/${PN} == sys-devel/gcc && ${EBUILD_PHASE} == unpack ]]; then
    # Since 2.3 > 2.12 in numerical terms, just compare 2.X to 2.Y, will break
    # if >=3.0 is ever released
    VERS=$(/usr/bin/ldd --version | head -n1 | grep -o ") [0-9]\.[0-9]\+" | cut -d. -f2 )
    if [[ $VERS -lt 12 ]]; then # compare host glibc 2.x to 2.12
        ewarn "Your host glibc is too old; disabling automatic fortify. bug 289757"
        EPATCH_EXCLUDE+=" 10_all_gcc-default-fortify-source.patch" # <=gcc-4.5*
        EPATCH_EXCLUDE+=" 10_all_default-fortify-source.patch" # >=gcc-4.6*
    fi
fi

if [[ ${EBUILD_PHASE} == setup ]]; then
    VERS=$(/usr/bin/ldd --version | head -n1 | grep -o ") [0-9]\.[0-9]\+" | cut -d. -f2 )
    if [[ $VERS -lt 6 && "${CFLAGS} " != *'gnu89-inline '* ]]; then # compare host glibc 2.x to 2.6
        einfo "Your host glibc is too old; enabling -fgnu89-inline compiler flag. bug 473524"
        CFLAGS="${CFLAGS} -fgnu89-inline" # for C only
    fi  
fi

# vim: set syn=sh expandtab ts=4:
