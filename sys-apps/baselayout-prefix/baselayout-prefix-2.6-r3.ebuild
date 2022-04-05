# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib

# just use "upstream" sources
MY_P=${P/-prefix/}
MY_PN=${PN/-prefix/}
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Filesystem baselayout and init scripts"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/${MY_PN}.git"
	inherit git-r3
else
	SRC_URI="https://gitweb.gentoo.org/proj/${MY_PN}.git/snapshot/${MY_P}.tar.bz2"
	KEYWORDS="~arm ~arm64 ~ppc64 ~riscv ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="build +split-usr"

RDEPEND="!sys-apps/baselayout"  #681760

my_prefix_commits=(
	# commits in reverse order as listed by:
	# git log --decorate=no --oneline --no-abbrev-commit origin/master..
	bb4c4f5f45b6798f5c9658e0e862077c404c675c # prefix-stack: ROOTPATH needs EPREFIX before BROOT
	a054fcc408ad48f775f7379834385c6a707d7a53 # also create etc/gentoo-release
	5926fe447541607ed137d67ca84080326584b2fc # create usr/bin during layout-usrmerge
	395424f90c8ca6969589905cbf86d74fae9d7ea6 # add prefix-stack support
	95a8e95af948014d024842892be1405d656ab5fc # add prefix-guest support
	c88ceddbfc6a965dc0153aef21e012e774d9e30c # sync prefix usage for Makefile target 'layout'
	c9338e89cdb603c1e08998bba28fbc977a62fc51 # add prefix support per Makefile target 'install'
)
for my_c in ${my_prefix_commits[*]}
do
	SRC_URI+=" https://github.com/haubi/gentoo-baselayout/commit/${my_c}.patch -> ${PN}-${my_c}.patch"
	PATCHES=( "${DISTDIR}/${PN}-${my_c}.patch" "${PATCHES[@]}" )
done
unset my_prefix_commits my_c

pkg_setup() {
	multilib_layout
}

# Create our multilib dirs - the Makefile has no knowledge of this
multilib_layout() {
	use prefix && return 0
	local dir def_libdir libdir libdirs
	local prefix prefix_lst
	def_libdir=$(get_abi_LIBDIR $DEFAULT_ABI)
	libdirs=$(get_all_libdirs)
	: ${libdirs:=lib}	# it isn't that we don't trust multilib.eclass...

	if [[ -z "${SYMLINK_LIB}" || ${SYMLINK_LIB} = no ]] ; then
		prefix_lst=( "${EROOT}"{,usr/,usr/local/} )
		for prefix in ${prefix_lst[@]}; do
			for libdir in ${libdirs}; do
				dir="${prefix}${libdir}"
				if [[ -e "${dir}" ]]; then
					[[ ! -d "${dir}" ]] &&
						die "${dir} exists but is not a directory"
					continue
				fi
				if ! use split-usr && [[ ${prefix} = ${EROOT} ]]; then
					einfo "symlinking ${dir} to usr/${libdir}"
					ln -s usr/${libdir} ${dir} ||
						die " Unable to make ${dir} symlink"
				else
					einfo "creating directory ${dir}"
					mkdir -p "${dir}" ||
						die "Unable to create ${dir} directory"
				fi
			done
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
		prefix_lst=( "${EROOT}"{,usr/,usr/local/} )
	else
		prefix_lst=( "${EROOT}"{usr/,usr/local/} )
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
					if [[ -d ${prefix}lib32 && ! -h ${prefix}lib32 ]] ; then
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
	if ! use split-usr ; then
		for libdir in ${libdirs}; do
			if [[ ! -e "${EROOT}${libdir}" ]]; then
				ln -s usr/"${libdir}" "${EROOT}${libdir}"
			fi
		done
	fi
}

pkg_preinst() {
	# This is written in src_install (so it's in CONTENTS), but punt all
	# pending updates to avoid user having to do etc-update (and make the
	# pkg_postinst logic simpler).
	rm -f "${EROOT}"/etc/._cfg????_gentoo-release

	# We need to install directories and maybe some dev nodes when building
	# stages, but they cannot be in CONTENTS.
	# Also, we cannot reference $S as binpkg will break so we do this.
	multilib_layout
	if use build ; then
		if use split-usr ; then
			emake -C "${ED}/usr/share/${PN}" DESTDIR="${ROOT}" layout
		else
			emake -C "${ED}/usr/share/${PN}" DESTDIR="${ROOT}" layout-usrmerge
		fi
	fi
	rm -f "${ED}"/usr/share/${PN}/Makefile
}

src_prepare() {
	default

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
	echo "LDPATH='${ldpaths#:}'" >> etc/env.d/50baselayout
}

src_configure() {
	local OS
	# although having a prefix, RAP uses full Linux baselayout
	OS=$(usex prefix-stack prefix-stack \
		 $(usex prefix-guest prefix-guest \
		   Linux ) )
	# set up immutable Makefile variables once
	sed -e "/^EPREFIX\s*?\?=\s*$/s|?\?=.*|= ${EPREFIX}|" \
		-e   "/^BROOT\s*?\?=\s*$/s|?\?=.*|= ${BROOT}|" \
		-e      "/^OS\s*?\?=\s*$/s|?\?=.*|= ${OS}|" \
		-i Makefile || die
}

src_install() {
	emake ROOT="${ROOT}" DESTDIR="${D}" install
	dodoc ChangeLog

	if [[ ${CHOST} == *-darwin* ]] ; then
		# add SDK path which contains development manpages
		echo "MANPATH=${EPREFIX}/MacOSX.sdk/usr/share/man" \
			> "${ED}"/etc/env.d/98macos-sdk
	fi

	# need the makefile in pkg_preinst
	insinto /usr/share/${PN}
	doins Makefile

	use prefix-guest || return 0

	# add a dummy to avoid Portage shebang errors
	dodir sbin
	cat > "${ED}"/sbin/runscript <<- EOF
		#!/usr/bin/env sh
		source "${EPREFIX}/lib/gentoo/functions.sh"

		eerror "runscript/openrc-run not supported by Gentoo Prefix Base System release ${PV}" 1>&2
		exit 1
	EOF
	chmod 755 "${ED}"/sbin/runscript || die
	cp "${ED}"/sbin/{runscript,openrc-run} || die
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
		cp -p "${EROOT}/usr/share/baselayout/${x}" "${EROOT}"/etc
	done

	# Force shadow permissions to not be world-readable #260993
	for x in shadow ; do
		[ -e "${EROOT}/etc/${x}" ] && chmod o-rwx "${EROOT}/etc/${x}"
	done

	# Take care of the etc-update for the user
	if [ -e "${EROOT}"/etc/._cfg0000_gentoo-release ] ; then
		mv "${EROOT}"/etc/._cfg0000_gentoo-release "${EROOT}"/etc/gentoo-release
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
		local bad_shells=$(awk -F: 'system("test -e " $7) { print $1 " - " $7}' "${EROOT}"/etc/passwd | sort)
		if [[ -n ${bad_shells} ]] ; then
			echo
			ewarn "The following users have non-existent shells!"
			ewarn "${bad_shells}"
		fi
	fi

	# https://bugs.gentoo.org/361349
	if use kernel_linux; then
		mkdir -p "${EROOT}"/run

		local found fstype mountpoint
		while read -r _ mountpoint fstype _; do
		[[ ${mountpoint} = /run ]] && [[ ${fstype} = tmpfs ]] && found=1
		done < "${ROOT}"/proc/mounts
		[[ -z ${found} ]] &&
			ewarn "You should reboot now to get /run mounted with tmpfs!"
	fi

	for x in ${REPLACING_VERSIONS}; do
		if ver_test ${x} -lt 2.4; then
			ewarn "After updating ${EROOT}/etc/profile, please run"
			ewarn "env-update && . ${EPREFIX}/etc/profile"
		fi

		if ver_test ${x} -lt 2.6; then
			ewarn "Please run env-update then log out and back in to"
			ewarn "update your path."
		fi
		# clean up after 2.5 typos
		# https://bugs.gentoo.org/show_bug.cgi?id=656380
		if [[ ${x} == 2.5 ]]; then
			rm -fr "${EROOT}{,usr"
		fi
	done

	if [[ -e "${EROOT}"/etc/env.d/00basic ]]; then
		ewarn "${EROOT}/etc/env.d/00basic is now ${EROOT}/etc/env.d/50baselayout"
		ewarn "Please migrate your changes."
	fi
}
