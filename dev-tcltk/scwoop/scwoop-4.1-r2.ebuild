# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Simple Composite Widget Object Oriented Package"
HOMEPAGE="http://jfontain.free.fr/scwoop41.htm"
SRC_URI="http://jfontain.free.fr/${P}.tar.gz"

LICENSE="jfontain"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

DEPEND="dev-tcltk/tcllib
	<dev-lang/tcl-9"
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
