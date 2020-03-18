# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Parallel lzip compressor"
HOMEPAGE="https://www.nongnu.org/lzip/plzip.html"
SRC_URI="https://download.savannah.gnu.org/releases/lzip/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

RDEPEND="app-arch/lzlib:0="
DEPEND=${RDEPEND}

src_configure() {
	local myconf=(
		--prefix="${EPREFIX}"/usr
		CXX="$(tc-getCXX)"
		CPPFLAGS="${CPPFLAGS}"
		CXXFLAGS="${CXXFLAGS}"
		LDFLAGS="${LDFLAGS}"
	)

	# not autotools-based
	./configure "${myconf[@]}" || die
}
