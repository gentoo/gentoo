# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic

DESCRIPTION="Computing Triangulations Of Point Configurations and Oriented Matroids"
HOMEPAGE="http://www.rambau.wm.uni-bayreuth.de/TOPCOM/"
SRC_URI="
	http://www.rambau.wm.uni-bayreuth.de/Software/TOPCOM-${PV}.tar.gz
	doc? ( http://www.rambau.wm.uni-bayreuth.de/TOPCOM/TOPCOM-manual.html )"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="doc examples static-libs"

DEPEND="
	dev-libs/gmp:0
	>=sci-libs/cddlib-094f"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-buildsystem.patch
)

src_prepare () {
	# ... and link in tree versions:
	append-libs -lgmp -lgmpxx -lcddgmp

	find external -delete || die

	default
}

src_install () {
	default

	use static-libs || rm -f "${ED}"/usr/$(get_libdir)/*a

	use examples && dodoc -r "${S}"/examples

	docinto /usr/share/doc/${PF}/html
	use doc && dodoc "${DISTDIR}"/TOPCOM-manual.html

	mv "${ED}"/usr/bin/cube "${ED}"/usr/bin/topcom_cube || die
}

pkg_postinst() {
	elog "Due to a file collision with media-libs/lib3ds the helper"
	elog "'cube' has been installed as topcom_cube (see bug #547030)."
}
