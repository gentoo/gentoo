# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/gocr/gocr-0.50.ebuild,v 1.2 2013/08/06 18:07:16 maekke Exp $

EAPI=4

DESCRIPTION="An OCR (Optical Character Recognition) reader"
HOMEPAGE="http://jocr.sourceforge.net"
SRC_URI="http://www-e.uni-magdeburg.de/jschulen/ocr/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc scanner tk"

DEPEND=">=media-libs/netpbm-9.12
	doc? ( >=media-gfx/transfig-3.2 app-text/ghostscript-gpl )
	tk? ( dev-lang/tk )"
RDEPEND="${DEPEND}
	tk? (
		media-gfx/xli
		scanner? ( media-gfx/xsane )
	)"

src_compile() {
	local mymakes="src man"

	use doc && mymakes="${mymakes} doc examples"

	emake ${mymakes}
}

src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" exec_prefix="${EPREFIX}/usr" install
	dodoc AUTHORS BUGS CREDITS HISTORY RE* TODO

	# remove the tk frontend if tk is not selected
	use tk || rm "${ED}"/usr/bin/gocr.tcl
	# and install the documentation and examples
	if use doc ; then
		dodoc doc/gocr.html doc/examples.txt doc/unicode.txt
		insinto /usr/share/doc/${PF}/examples
		doins "${S}"/examples/*.{fig,tex,pcx}
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
