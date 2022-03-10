# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="C language version of lzip"
HOMEPAGE="https://www.nongnu.org/lzip/clzip.html"
SRC_URI="https://download.savannah.gnu.org/releases/lzip/clzip/${P/_/-}.tar.gz"
S="${WORKDIR}/${P/_/-}"

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
