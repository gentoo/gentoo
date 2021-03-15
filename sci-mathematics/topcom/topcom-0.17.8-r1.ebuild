# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools flag-o-matic

DESCRIPTION="Computing Triangulations Of Point Configurations and Oriented Matroids"
HOMEPAGE="http://www.rambau.wm.uni-bayreuth.de/TOPCOM/"
SRC_URI="
	http://www.rambau.wm.uni-bayreuth.de/Software/TOPCOM-${PV}.tar.gz
	doc? ( http://www.rambau.wm.uni-bayreuth.de/TOPCOM/TOPCOM-manual.html )
"
KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="doc examples"

DEPEND="
	dev-libs/gmp:0
	>=sci-libs/cddlib-094f
"
RDEPEND="${DEPEND}"
BDEPEND="app-shells/tcsh"

PATCHES=( "${FILESDIR}/${P}-buildsystem.patch" )

src_prepare () {
	default

	# ... and link in tree versions:
	append-libs -lgmp -lgmpxx -lcddgmp
	append-cxxflags -I/usr/include/cddlib

	eautoreconf

	find external -delete || die
}

src_configure() {
	econf --disable-static
}

src_install () {
	if use doc ; then
		HTML_DOCS=( "${DISTDIR}/TOPCOM-manual.html" )
	fi

	default

	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		dodoc -r examples
	fi

	mv "${ED}/usr/bin/cube" "${ED}/usr/bin/topcom_cube" || die

	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	elog "Due to a file collision with media-libs/lib3ds the helper"
	elog "'cube' has been installed as topcom_cube (see bug #547030)."
}
