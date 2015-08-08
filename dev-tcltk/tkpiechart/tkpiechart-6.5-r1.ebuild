# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit multilib

DESCRIPTION="create and update 2D or 3D pie charts in a Tcl/Tk application"
HOMEPAGE="http://jfontain.free.fr/piechart6.htm"
SRC_URI="http://jfontain.free.fr/${P}.tar.bz2"

LICENSE="jfontain"
KEYWORDS="amd64 ~ppc x86"
SLOT="0"
IUSE=""

DEPEND=">=dev-lang/tk-8.3
	dev-tcltk/tcllib"

src_install() {
	dodir /usr/$(get_libdir)/tkpiechart
	./instapkg.tcl "${D}"/usr/$(get_libdir)/tkpiechart || die

	dodoc CHANGES CONTENTS README TODO || die
	dohtml *.gif *.htm || die
	docinto demo
	dodoc demo* || die
}
