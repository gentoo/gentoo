# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A C++ Library and a script language tool to create Flash (SWF) movies up to version 8"
HOMEPAGE="http://www.m2osw.com/sswf.html"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.bz2
	mirror://sourceforge/${PN}/${P}-doc.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug doc examples"

RDEPEND="virtual/jpeg
	media-libs/freetype"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	econf --disable-dependency-tracking --disable-docs \
		$(use_enable debug) $(use_enable debug yydebug)
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed."

	dodoc README.txt doc/{ASC-TODO,AUTHORS,CHANGES,LINKS,NOTES,TODO}.txt
	rm -f "${D}"/usr/share/${PN}/*.txt

	use examples || rm -rf "${D}"/usr/share/${PN}/samples

	doman doc/man/man1/*.1

	if use doc; then
		doman doc/man/man3/action_script_v3.3
		doman doc/man/man3/libsswf*.3
		doman doc/man/man3/sswf*.3
		dohtml -r doc/html/*
	fi
}
