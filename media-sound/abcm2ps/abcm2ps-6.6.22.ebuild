# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/abcm2ps/abcm2ps-6.6.22.ebuild,v 1.3 2013/01/22 17:33:09 ago Exp $

EAPI=5

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
