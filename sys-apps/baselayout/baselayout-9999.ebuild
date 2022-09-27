# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib prefix

DESCRIPTION="Filesystem baselayout and init scripts"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://gitweb.gentoo.org/proj/${PN}.git/snapshot/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+split-usr"

RDEPEND="!sys-apps/baselayout-prefix"

pkg_pretend() {
	if [[ ${SYMLINK_LIB} == yes ]]; then
		eerror "Please migrate to a profile with SYMLINK_LIB=no"
		die "SYMLINK_LIB=yes is not supported"
	fi
}

src_prepare() {
	default

	# don't want symlinked directories in PATH on systems with usr-merge
	if ! use split-usr && ! use prefix-guest; then
		sed \
			-e 's|:/usr/sbin:|:|g' \
			-e 's|:/sbin:|:|g' \
			-e 's|:/bin:|:|g' \
			-i etc/env.d/50baselayout || die
	fi

	if use prefix; then
		hprefixify -e "/EUID/s,0,${EUID}," -q '"' etc/profile
		hprefixify etc/shells share.Linux/passwd
		hprefixify -w '/PATH=/' etc/env.d/50baselayout
		hprefixify -w 1 etc/env.d/50baselayout
		echo PATH=/usr/sbin:/sbin:/usr/bin:/bin >> etc/env.d/99host || die

		# change branding
		sed -i \
			-e '/gentoo-release/s/Gentoo Base/Gentoo Prefix Base/' \
			-e '/make_os_release/s/${OS}/Prefix/' \
			Makefile || die
	fi

	# handle multilib paths.  do it here because we want this behavior
	# regardless of the C library that you're using.  we do explicitly
	# list paths which the native ldconfig searches, but this isn't
	# problematic as it doesn't change the resulting ld.so.cache or
	# take longer to generate.  similarly, listing both the native
	# path and the symlinked path doesn't change the resulting cache.
	local libdir ldpaths
	for libdir in $(get_all_libdirs) ; do
		if use split-usr || use prefix-guest; then
			ldpaths+=":${EPREFIX}/${libdir}"
		fi
		ldpaths+=":${EPREFIX}/usr/${libdir}"
		ldpaths+=":${EPREFIX}/usr/local/${libdir}"
	done
	echo "LDPATH='${ldpaths#:}'" >> etc/env.d/50baselayout || die
}

src_install() {
	# Install directories affected by the 'split-usr' USE flag.
	# This is simpler to do in the ebuild than the Makefile.
	keepdir /usr/{bin,lib}
	if use split-usr; then
		keepdir /usr/sbin
		keepdir /{bin,sbin,lib}
	else
		dosym bin /usr/sbin
		dosym usr/bin /bin
		dosym usr/bin /sbin
		dosym usr/lib /lib
	fi

	local libdir
	for libdir in $(get_all_libdirs); do
		# We installed 'lib' above, so skip it here.
		[[ ${libdir} == lib ]] && continue
		keepdir /usr/${libdir}
		if use split-usr; then
			keepdir /${libdir}
		else
			dosym usr/${libdir} /${libdir}
		fi
	done

	dosym ../proc/self/mounts /etc/mtab
	dosym ../run /var/run
	dosym ../run/lock /var/lock

	emake \
		OS=Linux \
		DESTDIR="${ED}" \
		install

	if [[ ${CHOST} == *-darwin* ]] ; then
		# add SDK path which contains development manpages
		echo "MANPATH=${EPREFIX}/MacOSX.sdk/usr/share/man" \
			> "${ED}"/etc/env.d/98macos-sdk
	fi

	dodoc ChangeLog

	# bug 858596
	if use prefix-guest ; then
		dodir sbin
		cat > "${ED}"/sbin/runscript <<- EOF
			#!/usr/bin/env sh
			source "${EPREFIX}/lib/gentoo/functions.sh"

			eerror "runscript/openrc-run not supported by Gentoo Prefix Base System release ${PV}" 1>&2
			exit 1
		EOF
		chmod 755 "${ED}"/sbin/runscript || die
		cp "${ED}"/sbin/{runscript,openrc-run} || die
	fi
}

riscv_compat_symlink() {
	# Here we apply some special sauce for riscv.
	# Two multilib layouts exist for now:
	# 1) one level libdirs, (32bit) "lib" and (64bit) "lib64"
	#    these are chosen by us to closely resemble other arches
	# 2) two level libdirs, "lib64/lp64d" "lib64/lp64" "lib32/ilp32d" ...
	#    this is the glibc/gcc default
	# Unfortunately, the default has only one fallback, which is "lib"
	# for both 32bit and 64bit. So things do not break in 1), we need
	# to provide compatibility symlinks...

	# This function has exactly two parameters:
	# - the default libdir, to determine if 1) or 2) applies
	# - the location of the symlink (which points to ".")

	# Note: we call this only in the ${SYMLINK_LIB} = no codepath, since
	# there never was a ${SYMLINK_LIB} = yes riscv profile.

	# are we on a one level libdir profile? is there no symlink yet?
	if [[ ${1} != */* && ! -L ${EROOT}${2} ]]; then
		dosym . "${2}"
	fi
}

pkg_preinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		local INSTALL=${INSTALL:-install}

		# These are often mount points, so we don't want baselayout to own them.
		${INSTALL} -dv "${EROOT}"/{boot,dev,home,media,mnt,opt,proc,run,sys}

		# Avoid owning dirs in /var.
		${INSTALL} -dv "${EROOT}"/var/{cache,empty,lib,log,spool}

		# Temporary directories.
		${INSTALL} -dv -m1777 "${EROOT}"/{,var/}tmp

		# root's home directory.
		${INSTALL} -dv -m0700 "${EROOT}"/root

		# Avoid QA warning about installing files in /usr/local.
		${INSTALL} -dv "${EROOT}"/usr/local/{bin,sbin,lib}
		local libdir
		for libdir in $(get_all_libdirs); do
			${INSTALL} -dv "${EROOT}"/usr/local/${libdir}
		done
	fi

	if [[ ${CHOST} == riscv* ]]; then
		local def_libdir=$(get_abi_LIBDIR ${DEFAULT_ABI})
		riscv_compat_symlink "${def_libdir}" "/usr/${def_libdir}/${DEFAULT_ABI}"
		riscv_compat_symlink "${def_libdir}" "/usr/local/${def_libdir}/${DEFAULT_ABI}"
		if use split-usr; then
			riscv_compat_symlink "${def_libdir}" "/${def_libdir}/${DEFAULT_ABI}"
		fi
	fi
}

pkg_postinst() {
	local x

	# We installed some files to /usr/share/baselayout instead of /etc to stop
	# (1) overwriting the user's settings
	# (2) screwing things up when attempting to merge files
	# (3) accidentally packaging up personal files with quickpkg
	# If they don't exist then we install them
	for x in master.passwd passwd shadow group fstab ; do
		[ -e "${EROOT}/etc/${x}" ] && continue
		[ -e "${EROOT}/usr/share/baselayout/${x}" ] || continue
		cp -p "${EROOT}/usr/share/baselayout/${x}" "${EROOT}"/etc || die
	done

	# Force shadow permissions to not be world-readable #260993
	for x in shadow ; do
		if [ -e "${EROOT}/etc/${x}" ] ; then
			chmod o-rwx "${EROOT}/etc/${x}" || die
		fi
	done

	# Take care of the etc-update for the user
	if [ -e "${EROOT}"/etc/._cfg0000_gentoo-release ] ; then
		mv "${EROOT}"/etc/._cfg0000_gentoo-release "${EROOT}"/etc/gentoo-release || die
	fi

	# whine about users that lack passwords #193541
	if [[ -e "${EROOT}"/etc/shadow ]] ; then
		local bad_users=$(sed -n '/^[^:]*::/s|^\([^:]*\)::.*|\1|p' "${EROOT}"/etc/shadow)
		if [[ -n ${bad_users} ]] ; then
			echo
			ewarn "The following users lack passwords!"
			ewarn ${bad_users}
		fi
	fi

	# whine about users with invalid shells #215698
	if [[ -e "${EROOT}"/etc/passwd ]] ; then
		local bad_shells=$(awk -F: 'system("test -e ${ROOT}" $7) { print $1 " - " $7}' "${EROOT}"/etc/passwd | sort)
		if [[ -n ${bad_shells} ]] ; then
			echo
			ewarn "The following users have non-existent shells!"
			ewarn "${bad_shells}"
		fi
	fi

	# https://bugs.gentoo.org/361349
	if use kernel_linux; then
		mkdir -p "${EROOT}"/run || die

		local found fstype mountpoint
		while read -r _ mountpoint fstype _; do
		[[ ${mountpoint} = /run && ${fstype} = tmpfs ]] && found=1
		done < "${ROOT}"/proc/mounts
		[[ -z ${found} ]] &&
			ewarn "You should reboot now to get /run mounted with tmpfs!"
	fi

	for x in ${REPLACING_VERSIONS}; do
		if ver_test 2.4 -lt ${x}; then
			ewarn "After updating ${EROOT}/etc/profile, please run"
			ewarn "env-update && . /etc/profile"
		fi

		if ver_test 2.6 -lt ${x}; then
			ewarn "Please run env-update then log out and back in to"
			ewarn "update your path."
		fi
		# clean up after 2.5 typos
		# https://bugs.gentoo.org/show_bug.cgi?id=656380
		if [[ ${x} == 2.5 ]]; then
			rm -fr "${EROOT}/{,usr" || die
		fi
	done

	if [[ -e "${EROOT}"/etc/env.d/00basic ]]; then
		ewarn "${EROOT}/etc/env.d/00basic is now ${EROOT}/etc/env.d/50baselayout"
		ewarn "Please migrate your changes."
	fi
}
