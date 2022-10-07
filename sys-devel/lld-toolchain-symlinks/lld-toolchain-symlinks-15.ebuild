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
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+native-symlinks"

RDEPEND="
	sys-devel/lld
"

src_install() {
	use native-symlinks || return

	local abi
	local dest=/usr/lib/llvm/${SLOT}/bin
	dodir "${dest}"
	dosym ../../../../bin/ld.lld "${dest}/ld"
	for abi in $(get_all_abis); do
		local abi_chost=$(get_abi_CHOST "${abi}")
		dosym ../../../../bin/ld.lld "${dest}/${abi_chost}-ld"
	done
}
