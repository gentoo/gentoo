# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Fast dense matrix arithmetic over GF(2^e) for 2 <= e <= 16"
HOMEPAGE="https://bitbucket.org/malb/m4rie/"
SRC_URI="https://bitbucket.org/malb/${PN}/downloads/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="debug static-libs"

DEPEND=">=sci-libs/m4ri-20140914"
RDEPEND="${DEPEND}"

src_configure() {
	# m4rie doesn't actually have any openmp code. The configure flag
	# stems from a mistaken belief that it needs to be there to use the
	# openmp code in m4ri.
	econf \
		--disable-openmp \
		$(use_enable debug) \
		$(use_enable static-libs static)
}

src_install(){
	default
	find "${ED}" -name '*.la' -delete || die
}
