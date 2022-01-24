# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Decompressor for the lzip format, written in C"
HOMEPAGE="https://www.nongnu.org/lzip/lunzip.html"
SRC_URI="https://download.savannah.gnu.org/releases/lzip/lunzip/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

src_configure() {
	# not autotools-based
	local myconf=(
		--prefix="${EPREFIX}"/usr
		CC="$(tc-getCC)"
		CPPFLAGS="${CPPFLAGS}"
		CFLAGS="${CFLAGS}"
		LDFLAGS="${LDFLAGS}"
	)

	./configure "${myconf[@]}" || die
}
