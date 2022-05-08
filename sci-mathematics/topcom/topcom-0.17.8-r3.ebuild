# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

MY_PV=$(ver_rs 0-2 _)
MY_P="${PN^^}-${MY_PV}"

DESCRIPTION="Computing Triangulations Of Point Configurations and Oriented Matroids"
HOMEPAGE="https://www.wm.uni-bayreuth.de/de/team/rambau_joerg/TOPCOM/index.html"
SRC_URI="
	https://www.wm.uni-bayreuth.de/de/team/rambau_joerg/TOPCOM-Downloads/${MY_P}.tgz
	https://www.wm.uni-bayreuth.de/de/team/rambau_joerg/TOPCOM-Manual/index.html -> TOPCOM-manual.html
"
KEYWORDS="~amd64 ~riscv ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="examples"

# need gmp[cxx] since we append -lgmpxx to LIBS
DEPEND="
	dev-libs/gmp:0[cxx]
	>=sci-libs/cddlib-094f
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-buildsystem.patch" )

HTML_DOCS=( "${DISTDIR}/TOPCOM-manual.html" )

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
