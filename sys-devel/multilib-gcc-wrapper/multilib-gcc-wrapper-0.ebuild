# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib

DESCRIPTION="Wrappers for gcc tools to be used on non-native CHOSTs"
HOMEPAGE="http://www.gentoo.org"
SRC_URI=""

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="sys-devel/gcc:="

S=${WORKDIR}

mkwrap() {
	einfo "	${2}"

	cat > "${T}"/wrapper <<-_EOF_
		#!${EPREFIX}/bin/sh
		exec ${1} $(get_abi_CFLAGS) "\${@}"
	_EOF_

	newbin "${T}"/wrapper "${2}"
}

src_install() {
	local host_prefix=${CHOST}
	# stolen from sys-devel/gcc-config
	# TODO: check if all of them actually support $(get_ABI_CFLAGS)
	local tools=(
		cpp cc gcc c++ g++ f77 g77 gcj gcjh gdc gdmd gfortran gccgo
	)

	cd "${EROOT%/}"/usr/bin || die
	eshopts_push -s nullglob

	# same as toolchain.eclass
	: ${TARGET_DEFAULT_ABI:=${DEFAULT_ABI}}
	: ${TARGET_MULTILIB_ABIS:=${MULTILIB_ABIS}}
	local ABI t e
	for ABI in $(get_all_abis TARGET); do
		[[ ${ABI} == ${TARGET_DEFAULT_ABI} ]] && continue

		einfo "Creating wrappers for ${ABI} ..."
		for t in "${tools[@]}"; do
			# look for both plain *-gcc and e.g. *-gcc-4.8.3
			# (but avoid *-gcc-nm)
			# note: nullglob applied above
			for e in ${host_prefix}[-]${t}{,-[0-9]*}; do
				local newname=$(get_abi_CHOST)-${e#${host_prefix}-}

				einfo "	${newname}"

				cat > "${T}"/wrapper <<-_EOF_
					#!${EPREFIX}/bin/sh
					exec ${e} $(get_abi_CFLAGS) "\${@}"
				_EOF_

				newbin "${T}"/wrapper "${newname}"
			done
		done
	done

	eshopts_pop
}
