# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="Log rotation software"
HOMEPAGE="https://github.com/fordmason/cronolog"
SRC_URI="http://cronolog.org/download/${P}.tar.gz"

LICENSE="GPL-2+ Apache-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"

PATCHES=(
	"${FILESDIR}"/${PV}-patches
	# rename and move into ${PV}-patches after -r3 removal
	"${FILESDIR}"/${P}-umask.patch
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_compile() {
	emake AR="$(tc-getAR)"
}
