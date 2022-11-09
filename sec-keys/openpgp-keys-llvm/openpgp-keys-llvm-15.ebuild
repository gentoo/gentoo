# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used to sign LLVM releases"
HOMEPAGE="https://github.com/llvm/llvm-project/releases/tag/llvmorg-9.0.1/"
SRC_URI="
	https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x474e22316abf4785a88c6e8ea2c794a986419d8a
		-> ${P}-tstellar.asc
	https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xd574bd5d1d0e98895e3bf90044f2485e45d59042
		-> ${P}-tobiashieta.asc
"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - llvm.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
