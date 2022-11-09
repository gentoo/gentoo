# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib

DESCRIPTION="Symlinks to use LLVM on binutils-free system"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:LLVM"
SRC_URI=""
S=${WORKDIR}

LICENSE="public-domain"
SLOT="${PV}"
KEYWORDS=""
PROPERTIES="live"
IUSE="multilib-symlinks +native-symlinks"

RDEPEND="
	sys-devel/llvm:${SLOT}
"

src_install() {
	use native-symlinks || return

	local tools=(
		addr2line ar dlltool nm objcopy objdump ranlib readelf size
		strings strip windres
	)
	local chosts=( "${CHOST}" )
	if use multilib-symlinks; then
		local abi
		for abi in $(get_all_abis); do
			chosts+=( "$(get_abi_CHOST "${abi}")" )
		done
	fi

	local chost t
	local dest=/usr/lib/llvm/${SLOT}/bin
	dodir "${dest}"
	for t in "${tools[@]}"; do
		dosym "llvm-${t}" "${dest}/${t}"
	done
	for chost in "${chosts[@]}"; do
		for t in "${tools[@]}"; do
			dosym "llvm-${t}" "${dest}/${chost}-${t}"
		done
	done
}
