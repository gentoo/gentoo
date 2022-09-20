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
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~ppc-macos ~x64-macos"
IUSE="+native-symlinks"

RDEPEND="
	sys-devel/llvm:${SLOT}
"

src_install() {
	use native-symlinks || return

	local tools=(
		addr2line ar dlltool nm objcopy objdump ranlib readelf size
		strings strip windres
	)

	local abi t
	local dest=/usr/lib/llvm/${SLOT}/bin
	dodir "${dest}"
	for t in "${tools[@]}"; do
		dosym "llvm-${t}" "${dest}/${t}"
	done
	for abi in $(get_all_abis); do
		local abi_chost=$(get_abi_CHOST "${abi}")
		for t in "${tools[@]}"; do
			dosym "llvm-${t}" "${dest}/${abi_chost}-${t}"
		done
	done
}
