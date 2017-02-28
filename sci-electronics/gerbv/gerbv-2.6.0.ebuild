# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit fdo-mime

DESCRIPTION="A RS-274X (Gerber) and NC drill (Excellon) file viewer"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://gerbv.geda-project.org/"

IUSE="doc examples static-libs unit-mm"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"
RESTRICT="test"

RDEPEND="
	x11-libs/gtk+:2
	x11-libs/cairo"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	econf \
		$(use_enable unit-mm) \
		--disable-update-desktop-database \
		$(use_enable static-libs static)
}

src_install () {
	emake DESTDIR="${D}" install
	dodoc AUTHORS BUGS ChangeLog CONTRIBUTORS HACKING NEWS README* TODO

	rm doc/Doxyfile.nopreprocessing
	if use doc; then
		find doc -name "Makefile*" -exec rm -f '{}' \;
		dodoc -r doc/*
	fi

	if use examples; then
		find example -name "Makefile*" -exec rm -f '{}' \;
		dodoc -r example/*
	fi
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
