# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="libsrs2 is the next generation Sender Rewriting Scheme library"
HOMEPAGE="https://www.libsrs2.org/"
SRC_URI="https://www.libsrs2.org/srs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="static-libs"

DEPEND="
	!dev-perl/Mail-SRS
	!mail-filter/libsrs_alt
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-parallel-make.diff"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_install() {
	default
	use static-libs || find "${ED}" -name '*.la' -delete
}
