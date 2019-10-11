# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Public-domain version of lzip compressor"
HOMEPAGE="http://www.nongnu.org/lzip/pdlzip.html"
SRC_URI="http://download.savannah.gnu.org/releases/lzip/pdlzip/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86"
IUSE=""

src_configure() {
	local myconf=(
		--prefix="${EPREFIX}"/usr
		CC="$(tc-getCC)"
		CFLAGS="${CFLAGS}"
		CPPFLAGS="${CPPFLAGS}"
		LDFLAGS="${LDFLAGS}"
	)

	# not autotools-based
	./configure "${myconf[@]}" || die
}
