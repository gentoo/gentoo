# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DATUMGRID="${PN}-datumgrid-1.8.tar.gz"

DESCRIPTION="PROJ coordinate transformation software"
HOMEPAGE="https://proj4.org/"
SRC_URI="
	http://download.osgeo.org/proj/${P}.tar.gz
	http://download.osgeo.org/proj/${DATUMGRID}
"

LICENSE="MIT"
SLOT="0/13"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="static-libs"

src_unpack() {
	unpack ${P}.tar.gz
	cd "${S}"/nad || die
	mv README README.NAD || die
	unpack ${DATUMGRID}
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--without-jni
}

src_install() {
	default
	cd nad || die
	dodoc README.{NAD,DATUMGRID}
	insinto /usr/share/proj
	insopts -m 755
	doins test27 test83
	insopts -m 644
	doins pj_out27.dist pj_out83.dist
	find "${D}" -name '*.la' -delete || die
}
