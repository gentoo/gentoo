# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

SRC_URI="http://www.tcs.hut.fi/Software/${PN}/${P}.zip"
DESCRIPTION="Compute Automorphism Groups and Canonical Labelings of Graphs"
HOMEPAGE="http://www.tcs.hut.fi/Software/bliss/"

LICENSE="LGPL-3"
SLOT="0/1"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc gmp static-libs"

RDEPEND="gmp? ( dev-libs/gmp:0= )"
DEPEND="${RDEPEND}
	app-arch/unzip
	doc? ( app-doc/doxygen )"

#patches from http://pkgs.fedoraproject.org/cgit/rpms/bliss.git/tree/
PATCHES=(
	"${FILESDIR}"/${P}-error.patch
	"${FILESDIR}"/${P}-rehn.patch
	"${FILESDIR}"/${P}-autotools.patch
)

src_prepare() {
	default
	cp "${FILESDIR}/${P}.1.in" "${PN}.1.in" || die
	rm Makefile || die
	eautoreconf
}

src_configure() {
	econf $(use_with gmp) $(use_enable static-libs static)
}

src_compile() {
	emake all $(usex doc html "")
}

src_install() {
	default
	use static-libs || find "${ED}" -name '*.la' -delete
	use doc && dodoc -r html
}
