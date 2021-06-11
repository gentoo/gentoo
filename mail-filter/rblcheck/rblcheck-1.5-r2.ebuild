# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Perform lookups in RBL-styles services"
HOMEPAGE="https://github.com/logic/rblcheck"
SRC_URI="https://github.com/logic/rblcheck/releases/download/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~mips ppc sparc x86"

PATCHES=(
	"${FILESDIR}"/${P}-configure.patch
)

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin rbl rblcheck

	dodoc README docs/rblcheck.ps docs/rblcheck.rtf
}
