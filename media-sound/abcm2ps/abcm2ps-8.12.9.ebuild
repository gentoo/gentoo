# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit toolchain-funcs

DESCRIPTION="A program to convert abc files to Postscript files"
HOMEPAGE="http://moinejf.free.fr/"
SRC_URI="http://moinejf.free.fr/${P}.tar.gz
	http://moinejf.free.fr/transpose_abc.pl"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="examples pango"

RDEPEND="pango? ( x11-libs/pango media-libs/freetype:2 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	econf \
		--enable-a4 \
		--enable-deco-is-roll \
		$(use_enable pango)
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin abcm2ps

	insinto /usr/share/${PN}
	doins *.fmt

	dodoc Changes README *.txt

	if use examples ; then
		docinto examples
		dodoc *.{abc,eps}
		docompress -x /usr/share/doc/${PF}/examples
	fi

	docinto contrib
	dodoc "${DISTDIR}"/transpose_abc.pl
}
