# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${PN}${PV}"

DESCRIPTION="Multi-Column Listbox Package"
HOMEPAGE="http://www.nemethi.de/tablelist/index.html"
SRC_URI="http://www.nemethi.de/tablelist/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="tablelist"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="examples doc"

RDEPEND="dev-lang/tcl:0"

src_install() {
	insinto /usr/$(get_libdir)/${MY_P}
	doins -r ${PN}* pkgIndex.tcl scripts
	use examples && dodoc -r demos
	use doc && docinto html && dodoc -r doc/.
	einstalldocs
}
