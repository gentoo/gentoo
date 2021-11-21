# Copyright 1999-2021 Gentoo Authors
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
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="build kernel_FreeBSD kernel_linux +split-usr"

pkg_setup() {
	multilib_layout
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

	case ${CHOST} in
	riscv*)
		# are we on a one level libdir profile? is there no symlink yet?
		if [[ ${1} != */* && ! -L ${2} ]] ; then
			ln -s . $2 || die "Unable to make $2 riscv compatibility symlink"
		fi
		;;
	esac
}

# Create our multilib dirs - the Makefile has no knowledge of this
multilib_layout() {
	local dir def_libdir libdir libdirs
	local prefix prefix_lst
	def_libdir=$(get_abi_LIBDIR $DEFAULT_ABI)
	libdirs=$(get_all_libdirs)

	if [[ -z "${SYMLINK_LIB}" || ${SYMLINK_LIB} = no ]] ; then
		prefix_lst=( "${EROOT}"/{,usr/,usr/local/} )
		for prefix in "${prefix_lst[@]}"; do
			for libdir in ${libdirs}; do
				dir="${prefix}${libdir}"
				if [[ -e "${dir}" ]]; then
					[[ ! -d "${dir}" ]] &&
						die "${dir} exists but is not a directory"
					continue
				fi
				if ! use split-usr && [[ ${prefix} = ${EROOT}/ ]]; then
					libdir="${libdir%%/*}"
					dir="${prefix}${libdir}"
					einfo "symlinking ${dir} to usr/${libdir}"
					ln -s usr/${libdir} ${dir} ||
						die "Unable to make ${dir} symlink"
				else
					einfo "creating directory ${dir}"
					mkdir -p "${dir}" ||
						die "Unable to create ${dir} directory"
				fi
			done
			riscv_compat_symlink "${def_libdir}" "${prefix}${def_libdir}/${DEFAULT_ABI}"
		done
		return 0
	fi

	[ -z "${def_libdir}" ] &&
		die "your DEFAULT_ABI=$DEFAULT_ABI appears to be invalid"

	# figure out which paths should be symlinks and which should be directories
	local dirs syms exp d
	for libdir in ${libdirs} ; do
		if use split-usr ; then
			exp=( {,usr/,usr/local/}${libdir} )
		else
			exp=( {usr/,usr/local/}${libdir} )
		fi
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
	if use split-usr ; then
		prefix_lst=( "${EROOT}"/{,usr/,usr/local/} )
	else
		prefix_lst=( "${EROOT}"/{usr/,usr/local/} )
	fi
	for prefix in "${prefix_lst[@]}"; do
		if [ "${SYMLINK_LIB}" = yes ] ; then
			# we need to make sure "lib" points to the native libdir
			if [ -h "${prefix}lib" ] ; then
				# it's already a symlink!  assume it's pointing to right place ...
				continue
			elif [ -d "${prefix}lib" ] ; then
				# "lib" is a dir, so need to convert to a symlink
				ewarn "Converting ${prefix}lib from a dir to a symlink"
				rm -f "${prefix}lib"/.keep || die
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
				mkdir -p "${prefix}${def_libdir}" || die #423571
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
					if [[ -d ${prefix}lib32 && ! -h ${prefix}lib32 ]] ; then
						rm -f "${prefix}lib32"/.keep || die
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
	if ! use split-usr ; then
		for libdir in ${libdirs}; do
			if [[ ! -e "${EROOT}${libdir}" ]]; then
				ln -s usr/"${libdir}" "${EROOT}${libdir}" ||
					die "Unable to make ${EROOT}${libdir} symlink"
			fi
		done
	fi
}

pkg_preinst() {
	# This is written in src_install (so it's in CONTENTS), but punt all
	# pending updates to avoid user having to do etc-update (and make the
	# pkg_postinst logic simpler).
	rm -f "${EROOT}"/etc/._cfg????_gentoo-release || die

	# We need to install directories and maybe some dev nodes when building
	# stages, but they cannot be in CONTENTS.
	# Also, we cannot reference $S as binpkg will break so we do this.
	multilib_layout
	if use build ; then
		if use split-usr ; then
			emake -C "${ED}/usr/share/${PN}" DESTDIR="${EROOT}" layout
		else
			emake -C "${ED}/usr/share/${PN}" DESTDIR="${EROOT}" layout-usrmerge
		fi
	fi
	rm -f "${ED}"/usr/share/${PN}/Makefile || die
}

src_prepare() {
	default
	if use prefix; then
		hprefixify -e "/EUID/s,0,${EUID}," -q '"' etc/profile
		hprefixify etc/{env.d/50baselayout,shells} share.Linux/passwd
		echo PATH=/usr/bin:/bin >> etc/env.d/99host
		echo ROOTPATH=/usr/sbin:/sbin:/usr/bin:/bin >> etc/env.d/99host
	fi

	# don't want symlinked directories in PATH on systems with usr-merge
	if ! use split-usr; then
		sed \
			-e 's|/usr/local/sbin:||g' \
			-e 's|:/usr/sbin:|:|g' \
			-e 's|:/sbin:|:|g' \
			-e 's|:/bin:|:|g' \
			-i etc/env.d/50baselayout || die
	fi

	# handle multilib paths.  do it here because we want this behavior
	# regardless of the C library that you're using.  we do explicitly
	# list paths which the native ldconfig searches, but this isn't
	# problematic as it doesn't change the resulting ld.so.cache or
	# take longer to generate.  similarly, listing both the native
	# path and the symlinked path doesn't change the resulting cache.
	local libdir ldpaths
	for libdir in $(get_all_libdirs) ; do
		use split-usr && ldpaths+=":${EPREFIX}/${libdir}"
		ldpaths+=":${EPREFIX}/usr/${libdir}"
		ldpaths+=":${EPREFIX}/usr/local/${libdir}"
	done
	echo "LDPATH='${ldpaths#:}'" >> etc/env.d/50baselayout

	# rc-scripts version for testing of features that *should* be present
	echo "Gentoo Base System release ${PV}" > etc/gentoo-release
}

src_install() {
	emake \
		OS=$(usex kernel_FreeBSD BSD Linux) \
		DESTDIR="${ED}" \
		install
	dodoc ChangeLog
	rm "${ED}"/etc/sysctl.d/README || die

	# need the makefile in pkg_preinst
	insinto /usr/share/${PN}
	doins Makefile

	# This is needed for https://bugs.gentoo.org/732142
	dodir /usr/lib
	mv "${ED}"/etc/os-release "${ED}"/usr/lib || die
	dosym ../usr/lib/os-release /etc/os-release
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
		[[ ${mountpoint} = /run ]] && [[ ${fstype} = tmpfs ]] && found=1
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
