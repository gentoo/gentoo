# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib

DESCRIPTION="Symlinks to use LLD on binutils-free system"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:LLVM"
SRC_URI=""
S=${WORKDIR}

LICENSE="public-domain"
SLOT="${PV}"
KEYWORDS=""
PROPERTIES="live"
IUSE="multilib-symlinks +native-symlinks"

RDEPEND="
	sys-devel/lld
"

src_install() {
	use native-symlinks || return

	local chosts=( "${CHOST}" )
	if use multilib-symlinks; then
		local abi
		for abi in $(get_all_abis); do
			chosts+=( "$(get_abi_CHOST "${abi}")" )
		done
	fi

	local dest=/usr/lib/llvm/${SLOT}/bin
	dodir "${dest}"
	dosym ../../../../bin/ld.lld "${dest}/ld"
	for chost in "${chosts[@]}"; do
		dosym ../../../../bin/ld.lld "${dest}/${chost}-ld"
	done
}
