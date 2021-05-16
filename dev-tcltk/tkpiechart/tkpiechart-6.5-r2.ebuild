# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib

DESCRIPTION="create and update 2D or 3D pie charts in a Tcl/Tk application"
HOMEPAGE="http://jfontain.free.fr/piechart6.htm"
SRC_URI="http://jfontain.free.fr/${P}.tar.bz2"

LICENSE="jfontain"
KEYWORDS="amd64 ~ppc x86"
SLOT="0"
IUSE=""

DEPEND="dev-lang/tk:*
	dev-tcltk/tcllib"
RDEPEND="${DEPEND}"

src_install() {
	dodir /usr/$(get_libdir)/tkpiechart
	./instapkg.tcl "${D}"/usr/$(get_libdir)/tkpiechart || die

	HTML_DOCS=( *.gif *.htm )
	einstalldocs
	docinto demo
	dodoc demo*
	docompress -x /usr/share/doc/${PF}/demo
}
