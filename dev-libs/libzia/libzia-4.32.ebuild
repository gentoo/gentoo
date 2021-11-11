# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Platform abstraction code for tucnak package"
HOMEPAGE="http://tucnak.nagano.cz"
SRC_URI="http://tucnak.nagano.cz/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="ftdi"

RDEPEND="dev-libs/glib:2
	x11-libs/gtk+:2
	media-libs/libsdl
	media-libs/libpng:0
	ftdi? ( dev-embedded/libftdi:1 )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

MAKEOPTS+=" -j1"

src_prepare() {
	eapply_user
	sed -i -e "s/docsdir/#docsdir/g" \
		-e "s/docs_/#docs_/g" Makefile.am || die

	# Fix QA-Warning "QA Notice: pkg-config files with wrong LDFLAGS detected"
	sed -i -e 's/@LDFLAGS@//' libzia.pc.in || die

	eautoreconf
}

src_configure() {
	econf \
		$(use_with ftdi) --with-sdl \
		--with-png --without-bfd \
		--disable-static
}

src_install() {
	emake DESTDIR="${D}" install
	find "${D}" -name '*.la' -type f -delete || die
}
