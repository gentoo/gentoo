# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="LVS tool (layout versus schematic comparison)"
HOMEPAGE="http://www.opencircuitdesign.com/netgen/index.html"
SRC_URI="http://www.opencircuitdesign.com/${PN}/archive/${P}.tgz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="X"

DEPEND="
	X? (
		dev-lang/tcl:0
		dev-lang/tk:0
		x11-libs/libX11
	)"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-1.4.40-tcl-bin-name.patch )

src_configure() {
	cd scripts || die
	econf $(use_with X x)
}

src_install() {
	emake DESTDIR="${D}" DOCDIR="${EPREFIX}"/usr/share/doc/${PF} install
	einstalldocs
	dodoc Changes TO_DO
}
