# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Scalable multiple alignment of protein sequences"
HOMEPAGE="http://www.clustal.org/omega/"
SRC_URI="http://www.clustal.org/omega/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs"

DEPEND="dev-libs/argtable"
RDEPEND="${DEPEND}"

src_prepare() {
	sed \
		-e "s:-O3::g" \
		-i configure.ac || die
	default
	eautoreconf
}

src_configure() {
	econf \
		--enable-shared \
		$(use_enable static-libs static)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
