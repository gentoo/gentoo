# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib

DESCRIPTION="Filesystem baselayout and init scripts"
HOMEPAGE="https://www.gentoo.org/"
SRC_URI="https://dev.gentoo.org/~williamh/dist/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="build kernel_linux"

pkg_setup() {
	multilib_layout
}

# Create our multilib dirs - the Makefile has no knowledge of this
multilib_layout() {
	local libdir libdirs=$(get_all_libdirs) def_libdir=$(get_abi_LIBDIR $DEFAULT_ABI)
	: ${libdirs:=lib}	# it isn't that we don't trust multilib.eclass...

	[ -z "${def_libdir}" ] && die "your DEFAULT_ABI=$DEFAULT_ABI appears to be invalid"

	# figure out which paths should be symlinks and which should be directories
	local dirs syms exp d
	for libdir in ${libdirs} ; do
		exp=( {,usr/,usr/local/}${libdir} )
		for d in "${exp[@]}" ; do
			# most things should be dirs
			if [ "${SYMLINK_LIB}" = "yes" ] && [ "${libdir}" = "lib" ] ; then
				[ ! -h "${d}" ] && [ -e "${d}" ] && dirs+=" ${d}"
			else
				[ -h "${d}" ] && syms+=" ${d}"
			fi
		done
	done
	if [ -n "${syms}${dirs}" ] ; then
		ewarn "Your system profile has SYMLINK_LIB=${SYMLINK_LIB:-no}, so that means you need to"
		ewarn "have these paths configured as follows:"
		[ -n "${dirs}" ] && ewarn "symlinks to '${def_libdir}':${dirs}"
		[ -n "${syms}" ] && ewarn "directories:${syms}"
		ewarn "The ebuild will attempt to fix these, but only for trivial conversions."
		ewarn "If things fail, you will need to manually create/move the directories."
		echo
	fi

	# setup symlinks and dirs where we expect them to be; do not migrate
	# data ... just fall over in that case.
	local prefix
	for prefix in "${EROOT}"{,usr/,usr/local/} ; do
		if [ "${SYMLINK_LIB}" = yes ] ; then
			# we need to make sure "lib" points to the native libdir
			if [ -h "${prefix}lib" ] ; then
				# it's already a symlink!  assume it's pointing to right place ...
				continue
			elif [ -d "${prefix}lib" ] ; then
				# "lib" is a dir, so need to convert to a symlink
				ewarn "Converting ${prefix}lib from a dir to a symlink"
				rm -f "${prefix}lib"/.keep
				if rmdir "${prefix}lib" 2>/dev/null ; then
					ln -s ${def_libdir} "${prefix}lib" || die
				else
					die "non-empty dir found where we needed a symlink: ${prefix}lib"
				fi
			else
				# nothing exists, so just set it up sanely
				ewarn "Initializing ${prefix}lib as a symlink"
				mkdir -p "${prefix}" || die
				rm -f "${prefix}lib" || die
				ln -s ${def_libdir} "${prefix}lib" || die
				mkdir -p "${prefix}${def_libdir}" #423571
			fi
		else
			# we need to make sure "lib" is a dir
			if [ -h "${prefix}lib" ] ; then
				# "lib" is a symlink, so need to convert to a dir
				ewarn "Converting ${prefix}lib from a symlink to a dir"
				rm -f "${prefix}lib" || die
				if [ -d "${prefix}lib32" ] ; then
					ewarn "Migrating ${prefix}lib32 to ${prefix}lib"
					mv "${prefix}lib32" "${prefix}lib" || die
				else
					mkdir -p "${prefix}lib" || die
				fi
			elif [ -d "${prefix}lib" ] && ! has lib32 ${libdirs} ; then
				# make sure the old "lib" ABI location does not exist; we
				# only symlinked the lib dir on systems where we moved it
				# to "lib32" ...
				case ${CHOST} in
				*-gentoo-freebsd*) ;; # We want it the other way on fbsd.
				i?86*|x86_64*|powerpc*|sparc*|s390*)
					if [ -d "${prefix}lib32" ] ; then
						rm -f "${prefix}lib32"/.keep
						if ! rmdir "${prefix}lib32" 2>/dev/null ; then
							ewarn "You need to merge ${prefix}lib32 into ${prefix}lib"
							die "non-empty dir found where there should be none: ${prefix}lib32"
						fi
					fi
					;;
				esac
			else
				# nothing exists, so just set it up sanely
				ewarn "Initializing ${prefix}lib as a dir"
				mkdir -p "${prefix}lib" || die
			fi
		fi
	done
}

pkg_preinst() {
	# Bug #217848 - Since the remap_dns_vars() called by pkg_preinst() of
	# the baselayout-1.x ebuild copies all the real configs from the user's
	# /etc/conf.d into ${D}, it makes them all appear to be the default
	# versions. In order to protect them from being unmerged after this
	# upgrade, modify their timestamps.
	touch "${EROOT}"/etc/conf.d/* 2>/dev/null

	# This is written in src_install (so it's in CONTENTS), but punt all
	# pending updates to avoid user having to do etc-update (and make the
	# pkg_postinst logic simpler).
	rm -f "${EROOT}"/etc/._cfg????_gentoo-release

	# We need to install directories and maybe some dev nodes when building
	# stages, but they cannot be in CONTENTS.
	# Also, we cannot reference $S as binpkg will break so we do this.
	multilib_layout
	if use build ; then
		emake -C "${ED}/usr/share/${PN}" DESTDIR="${EROOT}" layout || die
	fi
	rm -f "${ED}"/usr/share/${PN}/Makefile
}

src_prepare() {
	if use prefix; then
		sed -i -r\
			-e "/PATH=/!s:/(etc|usr/bin|bin):\"${EPREFIX}\"/\1:g" \
			-e "/PATH=/s|([:\"])/|\1${EPREFIX}/|g" \
			-e "/PATH=.*\/sbin/s|\"$|:/usr/sbin:/sbin\"|" \
			-e "/PATH=.*\/bin/s|\"$|:/usr/bin:/bin\"|" \
			etc/profile || die
		sed -i -r \
			-e "s:/(etc/env.d|opt|usr):${EPREFIX}/\1:g" \
			-e "/^PATH=/s|\"$|:${EPREFIX}/usr/sbin:${EPREFIX}/sbin\"|" \
			etc/env.d/00basic || die
		sed -i "s:/bin:${EPREFIX}/bin:" etc/shells || die
		sed -i -r \
			-e "s,:/(root|bin|sbin|var|),:${EPREFIX}/\1,g" \
			share.Linux/passwd || die
	fi

	# handle multilib paths.  do it here because we want this behavior
	# regardless of the C library that you're using.  we do explicitly
	# list paths which the native ldconfig searches, but this isn't
	# problematic as it doesn't change the resulting ld.so.cache or
	# take longer to generate.  similarly, listing both the native
	# path and the symlinked path doesn't change the resulting cache.
	local libdir ldpaths
	for libdir in $(get_all_libdirs) ; do
		ldpaths+=":${EPREFIX}/${libdir}:${EPREFIX}/usr/${libdir}"
		ldpaths+=":${EPREFIX}/usr/local/${libdir}"
	done
	echo "LDPATH='${ldpaths#:}'" >> etc/env.d/00basic

	# rc-scripts version for testing of features that *should* be present
	echo "Gentoo Base System release ${PV}" > etc/gentoo-release
}

src_install() {
	emake \
		OS=$(usex kernel_FreeBSD BSD Linux) \
		DESTDIR="${ED}" \
		install
	dodoc ChangeLog

	# need the makefile in pkg_preinst
	insinto /usr/share/${PN}
	doins Makefile
}

pkg_postinst() {
	local x

	# We installed some files to /usr/share/baselayout instead of /etc to stop
	# (1) overwriting the user's settings
	# (2) screwing things up when attempting to merge files
	# (3) accidentally packaging up personal files with quickpkg
	# If they don't exist then we install them
	for x in master.passwd passwd shadow group fstab ; do
		[ -e "${EROOT}etc/${x}" ] && continue
		[ -e "${EROOT}usr/share/baselayout/${x}" ] || continue
		cp -p "${EROOT}usr/share/baselayout/${x}" "${EROOT}"etc
	done

	# Force shadow permissions to not be world-readable #260993
	for x in shadow ; do
		[ -e "${EROOT}etc/${x}" ] && chmod o-rwx "${EROOT}etc/${x}"
	done

	# Take care of the etc-update for the user
	if [ -e "${EROOT}"etc/._cfg0000_gentoo-release ] ; then
		mv "${EROOT}"etc/._cfg0000_gentoo-release "${EROOT}"etc/gentoo-release
	fi

	# whine about users that lack passwords #193541
	if [[ -e "${EROOT}"etc/shadow ]] ; then
		local bad_users=$(sed -n '/^[^:]*::/s|^\([^:]*\)::.*|\1|p' "${EROOT}"/etc/shadow)
		if [[ -n ${bad_users} ]] ; then
			echo
			ewarn "The following users lack passwords!"
			ewarn ${bad_users}
		fi
	fi

	# baselayout leaves behind a lot of .keep files, so let's clean them up
	find "${EROOT}"lib*/rcscripts/ -name .keep -exec rm -f {} + 2>/dev/null
	find "${EROOT}"lib*/rcscripts/ -depth -type d -exec rmdir {} + 2>/dev/null

	# whine about users with invalid shells #215698
	if [[ -e "${EROOT}"etc/passwd ]] ; then
		local bad_shells=$(awk -F: 'system("test -e " $7) { print $1 " - " $7}' "${EROOT}"etc/passwd | sort)
		if [[ -n ${bad_shells} ]] ; then
			echo
			ewarn "The following users have non-existent shells!"
			ewarn "${bad_shells}"
		fi
	fi

	# https://bugs.gentoo.org/361349
	if use kernel_linux; then
		mkdir -p "${EROOT}"run

		if ! grep -qs "^tmpfs.*/run " "${ROOT}"proc/mounts ; then
			echo
			ewarn "You should reboot the system now to get /run mounted with tmpfs!"
		fi
	fi
}
