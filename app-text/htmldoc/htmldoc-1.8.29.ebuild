# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils toolchain-funcs

DESCRIPTION="Convert HTML pages into a PDF document"
SRC_URI="http://www.msweet.org/files/project1/${P}-source.tar.bz2"
HOMEPAGE="http://www.msweet.org/projects.php?Z1"

IUSE="fltk"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

DEPEND=">=media-libs/libpng-1.4:0=
	virtual/jpeg:0
	fltk? ( x11-libs/fltk:1 )
"
RDEPEND="${DEPEND}"

src_prepare() {
	# make sure not to use the libs htmldoc ships with
	mkdir foo ; mv jpeg foo/ ; mv png foo/ ; mv zlib foo/

	sed -i "s:^#define DOCUMENTATION \"\$prefix/share/doc/htmldoc\":#define DOCUMENTATION \"\$prefix/share/doc/${PF}/html\":" \
		configure || die

	eapply "${FILESDIR}/${PN}-destdir.patch" \
		   "${FILESDIR}/${PN}-break.patch"

	default
}

src_configure() {
	local myconf="$(use_with fltk gui)"

	CC=$(tc-getCC) CXX=$(tc-getCXX) \
	econf ${myconf}
	# Add missing -lfltk_images to LIBS
	if use fltk; then
		sed -i 's:-lfltk :-lfltk -lfltk_images :g' Makedefs || die
	fi
}

src_compile() {
	emake
}

src_install() {
	emake DESTDIR="${D}" install

	# Minor cleanups
	mv "${D}/usr/share/doc/htmldoc" "${D}/usr/share/doc/${PF}"
	dodir /usr/share/doc/${PF}/html
	mv "${D}"/usr/share/doc/${PF}/*.html "${D}/usr/share/doc/${PF}/html"
}
