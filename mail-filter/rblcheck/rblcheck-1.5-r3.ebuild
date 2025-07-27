# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs autotools

DESCRIPTION="Perform lookups in RBL-styles services"
HOMEPAGE="https://github.com/logic/rblcheck"
SRC_URI="https://github.com/logic/rblcheck/releases/download/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~mips ppc sparc x86"

RDEPEND="!net-libs/udns[tools]"

PATCHES=(
	"${FILESDIR}"/${P}-autoconf.patch
)

DOCS=( README docs/rblcheck.ps docs/rblcheck.rtf )

src_prepare() {
	default

	eautoreconf
}

src_compile() {
	emake CC="$(tc-getCC)"
}
