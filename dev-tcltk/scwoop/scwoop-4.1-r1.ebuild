# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Simple Composite Widget Object Oriented Package"
HOMEPAGE="http://jfontain.free.fr/scwoop41.htm"
SRC_URI="http://jfontain.free.fr/${P}.tar.gz"

LICENSE="jfontain"
KEYWORDS="amd64 ~ppc x86"
SLOT="0"
IUSE=""

DEPEND="dev-tcltk/tcllib"
RDEPEND="${DEPEND}"

HTML_DOCS=( scwoop.htm )

src_install() {
	dodir /usr/lib/scwoop
	./instapkg.tcl "${D}"/usr/lib/scwoop || die

	einstalldocs
	docompress -x /usr/share/doc/${PF}/demo
	docinto demo
	dodoc demo*
}
