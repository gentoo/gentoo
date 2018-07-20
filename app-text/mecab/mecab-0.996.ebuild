# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit autotools eutils

DESCRIPTION="Yet Another Part-of-Speech and Morphological Analyzer"
HOMEPAGE="https://taku910.github.io/mecab/"
SRC_URI="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/${PN}/${P}.tar.gz"

LICENSE="|| ( BSD LGPL-2.1 GPL-2 )"
KEYWORDS="amd64 ~arm hppa ia64 ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd"
SLOT="0"
IUSE="static-libs unicode"

DEPEND="dev-lang/perl
	virtual/libiconv"
RDEPEND=""
PDEPEND="|| (
		app-dicts/mecab-ipadic[unicode=]
		app-dicts/mecab-naist-jdic[unicode=]
	)"

src_prepare() {
	sed -i \
		-e "/CFLAGS/s/-O3/${CFLAGS}/" \
		-e "/CXXFLAGS/s/-O3/${CXXFLAGS}/" \
		configure.in || die
	epatch "${FILESDIR}/${PN}-0.98-iconv.patch"
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_with unicode charset UTF-8)
}

src_install() {
	default
	dodoc AUTHORS README
	dohtml -r doc/*

	use static-libs || find "${ED}" -name '*.la' -delete
}
