# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/getxbook/getxbook-1.0-r1.ebuild,v 1.1 2015/03/21 09:25:25 jlec Exp $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Download books from google, amazon, barnes and noble"
HOMEPAGE="http://njw.me.uk/software/getxbook/"
SRC_URI="http://njw.me.uk/software/getxbook/${P}.tar.bz2"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pdf djvu ocr tk"

DEPEND=""
RDEPEND="
	djvu? ( app-text/djvu )
	pdf? ( media-gfx/imagemagick )
	ocr? (
		app-text/tesseract
		pdf? ( media-gfx/exact-image app-text/pdftk )
		)
	tk? ( dev-lang/tk:0= )"

src_prepare() {
	epatch "${FILESDIR}"/${P}.patch
	tc-export CC AR RANLIB
}

src_install() {
	DOCS=( README LEGAL )
	default

	use pdf  && dobin extras/mkpdf.sh
	use djvu && dobin extras/mkdjvu.sh

	if use ocr; then
		dobin extras/mkocrtxt.sh
		use pdf  && dobin extras/mkocrpdf.sh
		use djvu && dobin extras/mkocrdjvu.sh
	fi
	use tk && dobin getxbookgui.tcl
}
