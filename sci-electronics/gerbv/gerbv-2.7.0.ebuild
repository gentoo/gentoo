# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools xdg

DESCRIPTION="A RS-274X (Gerber) and NC drill (Excellon) file viewer"
HOMEPAGE="http://gerbv.geda-project.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="doc examples unit-mm"
RESTRICT="test"

RDEPEND="
	x11-libs/gtk+:2
	x11-libs/cairo"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-2.7.0-fno-common-gcc10.patch )

src_configure() {
	econf \
		--disable-static \
		--disable-update-desktop-database \
		$(use_enable unit-mm)
}

src_install() {
	rm README-{git,release,win32}.txt || die
	default
	dodoc CONTRIBUTORS HACKING

	rm doc/Doxyfile.nopreprocessing || die
	if use doc; then
		find doc -name 'Makefile*' -delete || die
		dodoc -r doc/.
	fi

	if use examples; then
		find example -name 'Makefile*' -delete || die
		dodoc -r example/.
	fi

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
