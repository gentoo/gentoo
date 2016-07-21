# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils

DESCRIPTION="C++ library and tools for symbolic calculations"
SRC_URI="ftp://ftpthep.physik.uni-mainz.de/pub/GiNaC/${P}.tar.bz2"
HOMEPAGE="http://www.ginac.de/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc static-libs"

RDEPEND=">=sci-libs/cln-1.2.2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen
		   media-gfx/transfig
		   virtual/texi2dvi
		   dev-texlive/texlive-fontsrecommended
		 )"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.5.1-pkgconfig.patch
}

src_configure() {
	econf \
		--disable-rpath \
		$(use_enable static-libs static)
}

src_compile() {
	emake
	if use doc; then
		export VARTEXFONTS="${T}"/fonts
		cd "${S}/doc/reference"
		#pdf generation for reference failed (1.5.1), bug #264774
		#emake html pdf || die "emake doc reference failed"
		emake html
		cd "${S}/doc/tutorial"
		emake ginac.pdf ginac.html
	fi
}

src_install() {
	default
	if use doc; then
		cd doc
		insinto /usr/share/doc/${PF}
		newins tutorial/ginac.pdf tutorial.pdf
		insinto /usr/share/doc/${PF}/html/reference
		doins -r reference/html_files/*
		insinto /usr/share/doc/${PF}/html
		newins tutorial/ginac.html tutorial.html
		insinto /usr/share/doc/${PF}/examples
		doins examples/*.cpp examples/ginac-examples.txt
	fi
}
