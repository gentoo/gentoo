#!/bin/bash
# Copyright 1999-2012 Gentoo Foundation; Distributed under the GPL v2
# $Id$

type -P gmake  > /dev/null && alias make=gmake
type -P gpatch > /dev/null && alias patch=gpatch
type -P gsed   > /dev/null && alias sed=gsed
type -P gawk   > /dev/null && alias awk=gawk
type -P gfind  > /dev/null && alias find=gfind
type -P gxargs > /dev/null && alias xargs=gxargs

# Attempt to point the default SHELL used by configure scripts to bash.
# while most should work with BSD's bourne just fine, the extra scripts
# used by some applications (specially test scripts) use way too many bashisms.
# Alexis Ballier <29 May 2012>: Disable this, we should rather fix bugs and it
# seems to confuse libtool a couple of packages (dev-libs/libtar, net-dns/hesiod)
# export CONFIG_SHELL="/bin/bash"

# Hack to avoid every package that uses libiconv/gettext
# install a charset.alias that will collide with libiconv's one
# See bugs 169678, 195148 and 256129.
# Also the discussion on
# https://archives.gentoo.org/gentoo-dev/msg_8cb1805411f37b4eb168a3e680e531f3.xml
bsd-post_src_install()
{
	if [ "${PN}" != "libiconv" -a -e "${D}"/usr/lib*/charset.alias ] ; then
		rm -f "${D}"/usr/lib*/charset.alias
	fi
}

# These are because of
# https://archives.gentoo.org/gentoo-dev/msg_529a0806ed2cf841a467940a57e2d588.xml
# The profile-* ones are meant to be used in etc/portage/profile.bashrc by user
# until there is the registration mechanism.
profile-post_src_install() { bsd-post_src_install ; }
        post_src_install() { bsd-post_src_install ; }


# Another hack to fix old versions of install-sh (automake) where a non-gnu
# mkdir is not considered thread-safe (make install errors with -j > 1)
bsd-patch_install-sh() {
	# Do nothing if we don't have patch installed:
	if [[ -z $(type -P gpatch) ]]; then
		return 0
	fi

        # Do nothing if $S does not exist
        [ -d "${S}" ] || return 0

	local EPDIR="${ECLASSDIR}/ELT-patches/install-sh"
	local EPATCHES="${EPDIR}/1.5.6 ${EPDIR}/1.5.4 ${EPDIR}/1.5"
	local ret=0
	cd "${S}"
	for file in $(find . -name "install-sh" -print); do
		if [[ -n $(egrep "scriptversion=2005|scriptversion=2004" ${file}) ]]; then
			einfo "Automatically patching parallel-make unfriendly install-sh."
			# Stolen from libtool.eclass
			for mypatch in ${EPATCHES}; do
				if gpatch -p0 --dry-run "${file}" "${mypatch}" &> "${T}/patch_install-sh.log"; then
					gpatch -p0 -g0 --no-backup-if-mismatch "${file}" "${mypatch}" \
						&> "${T}/patch_install-sh.log"
					ret=$?
					break
				else
					ret=1
				fi
			done
			if [[ ret -eq 0 ]]; then
				einfo "Patch applied successfully on \"${file}\"."
			else
				ewarn "Unable to apply install-sh patch. "
				ewarn "If you experience errors during install phase, try with MAKEOPTS=\"-j1\""
			fi
		fi
	done
}

# It should be run after everything has been unpacked/patched, some developers
# do patch this little bastard from time to time.
# So do it after unpack() for EAPI=0|1 and after prepare() for everything else.
if [[ -n $EAPI ]] ; then
	case "$EAPI" in
		0|1)
			profile-post_src_unpack() { bsd-patch_install-sh ; }
			post_src_unpack() { bsd-patch_install-sh ; }
			;;
		*)
			profile_post_src_prepare() { bsd-patch_install-sh ; }
			post_src_prepare() { bsd-patch_install-sh ; }
			;;
	esac
fi
