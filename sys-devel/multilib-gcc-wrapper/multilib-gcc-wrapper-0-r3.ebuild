# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib

DESCRIPTION="Wrappers for gcc tools to be used on non-native CHOSTs"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="sys-devel/gcc:="

src_install() {
	local host_prefix=${CHOST}
	# stolen from sys-devel/gcc-config
	# TODO: check if all of them actually support $(get_ABI_CFLAGS)
	local tools=(
		cpp cc gcc c++ g++ f77 g77 gcj gcjh gdc gdmd gfortran gccgo
	)

	cd "${ESYSROOT}"/usr/bin || die
	shopt -s nullglob

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

				newbin - "${newname}" <<-_EOF_
					#!${EPREFIX}/bin/sh
					exec ${e} $(get_abi_CFLAGS) "\${@}"
				_EOF_
			done
		done
	done

	shopt -u nullglob
}

pkg_postinst() {
	if [[ -z ${ROOT} && -f ${EPREFIX}/usr/share/eselect/modules/compiler-shadow.eselect ]] ; then
		eselect compiler-shadow update all
	fi
}

pkg_postrm() {
	if [[ -z ${ROOT} && -f ${EPREFIX}/usr/share/eselect/modules/compiler-shadow.eselect ]] ; then
		eselect compiler-shadow clean all
	fi
}
