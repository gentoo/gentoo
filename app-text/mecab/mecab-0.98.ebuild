# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/mecab/mecab-0.98.ebuild,v 1.9 2013/08/03 12:41:27 hattya Exp $

EAPI="2"

inherit autotools eutils

DESCRIPTION="Yet Another Part-of-Speech and Morphological Analyzer"
HOMEPAGE="http://mecab.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="|| ( BSD LGPL-2.1 GPL-2 )"
KEYWORDS="amd64 ~arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
SLOT="0"
IUSE="unicode"
RESTRICT="test"

DEPEND="dev-lang/perl
	virtual/libiconv"
RDEPEND=""
PDEPEND="app-dicts/mecab-ipadic"

src_prepare() {
	sed -i \
		-e "/CFLAGS/s/-O3/${CFLAGS}/" \
		-e "/CXXFLAGS/s/-O3/${CXXFLAGS}/" \
		configure.in || die
	epatch "${FILESDIR}/${P}-iconv.patch"
	eautoreconf
}

src_configure() {
	econf $(use_with unicode charset UTF-8) || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS README || die
	dohtml -r doc || die
}
