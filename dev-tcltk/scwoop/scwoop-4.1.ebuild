# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

DESCRIPTION="Simple Composite Widget Object Oriented Package"
HOMEPAGE="http://jfontain.free.fr/scwoop41.htm"
SRC_URI="http://jfontain.free.fr/${P}.tar.gz"

LICENSE="jfontain"
KEYWORDS="x86 amd64 ~ppc"
SLOT="0"
IUSE=""

DEPEND="dev-tcltk/tcllib"

src_install() {
	dodir /usr/lib/scwoop
	./instapkg.tcl "${D}"/usr/lib/scwoop || die

	dodoc CHANGES CONTENTS COPYRIGHT INSTALL README TODO
	dohtml scwoop.htm
	docinto demo
	dodoc demo*
}
