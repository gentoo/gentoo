# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils flag-o-matic

DESCRIPTION="Computing Triangulations Of Point Configurations and Oriented Matroids"
HOMEPAGE="http://www.rambau.wm.uni-bayreuth.de/TOPCOM/"
SRC_URI="
	http://www.uni-bayreuth.de/departments/wirtschaftsmathematik/rambau/Software/TOPCOM-${PV}.tar.gz
	doc? ( http://www.rambau.wm.uni-bayreuth.de/TOPCOM/TOPCOM-manual.html )"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="doc examples static-libs"

DEPEND="
	>=dev-libs/gmp-5.0.5
	>=sci-libs/cddlib-094f"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/TOPCOM-${PV}

PATCHES=(
	"${FILESDIR}"/${P}-no-internal-libs.patch
	"${FILESDIR}"/${P}-buildsystem.patch
	)

src_prepare () {
	# ... and link in tree versions:
	append-libs -lgmp -lgmpxx -lcddgmp

	find external -delete || die

	mv configure.{in,ac} || die

	autotools-utils_src_prepare
}

src_install () {
	autotools-utils_src_install

	use static-libs || rm -f "${ED}"/usr/$(get_libdir)/*a

	use doc && dohtml "${DISTDIR}"/TOPCOM-manual.html

	use examples && dodoc -r "${S}"/examples

	mv "${ED}"/usr/bin/cube "${ED}"/usr/bin/topcom_cube || die
}

pkg_postinst() {
	elog "Due to a file collision with media-libs/lib3ds the helper"
	elog "'cube' has been installed as topcom_cube (see bug #547030)."
}
