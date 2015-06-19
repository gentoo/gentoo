# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/blahtexml/blahtexml-0.9.ebuild,v 1.4 2014/08/15 13:58:49 blueness Exp $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="TeX-to-MathML converter"
HOMEPAGE="http://gva.noekeon.org/blahtexml"
SRC_URI="http://gva.noekeon.org/${PN}/${P}-src.tar.gz"

LICENSE="BSD CC-BY-3.0 ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="doc"

RDEPEND="dev-libs/xerces-c"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? (
		app-text/texlive-core
		dev-libs/libxslt
		dev-tex/latex2html )"

src_prepare() {
	tc-export CC CXX
	epatch "${FILESDIR}"/${P}-{Makefile,gcc-4.7}.patch
}

src_compile() {
	emake blahtex{,ml}-linux
	use doc && emake doc
}

src_install() {
	dobin blahtex ${PN}
	doman "${FILESDIR}"/${PN}.1
	use doc && dodoc Documentation/manual.pdf
}
