# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_PV=$(ver_rs 0-2 _)
MY_P="${PN^^}-${MY_PV}"

DESCRIPTION="Computing Triangulations Of Point Configurations and Oriented Matroids"
HOMEPAGE="https://www.wm.uni-bayreuth.de/de/team/rambau_joerg/TOPCOM/index.html"
SRC_URI="
	https://www.wm.uni-bayreuth.de/de/team/rambau_joerg/TOPCOM-Downloads/${MY_P}.tgz
	doc? ( https://www.wm.uni-bayreuth.de/de/team/rambau_joerg/TOPCOM-Manual/TOPCOM-manual.pdf )
"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="doc examples"

DEPEND="
	dev-libs/gmp:0[cxx]
	sci-libs/cddlib
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-buildsystem.patch" )

src_prepare () {
	default
	eautoreconf
	find external -delete || die
}

src_install () {
	default

	use doc && dodoc "${DISTDIR}/TOPCOM-manual.pdf"

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
