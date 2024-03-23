# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Platform abstraction code for tucnak package"
HOMEPAGE="http://tucnak.nagano.cz"
SRC_URI="http://tucnak.nagano.cz/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ftdi"

RDEPEND="dev-libs/glib:2
	x11-libs/gtk+:2
	media-libs/libsdl2
	media-libs/sdl2-ttf
	media-libs/libpng:0
	ftdi? ( dev-embedded/libftdi:1 )
	elibc_musl? ( sys-libs/libunwind )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

MAKEOPTS+=" -j1"

src_prepare() {
	eapply_user
	sed -i -e "s/docsdir/#docsdir/g" \
		-e "s/docs_/#docs_/g" Makefile.am || die

	# fix build for MUSL (bug #832235)
	if use elibc_musl ; then
		sed -i -e "s/ backtrace(/ unw_backtrace(/" src/zbfd.c || die
	fi
	eautoreconf
}

src_configure() {
	use elibc_musl && append-libs -lunwind
	econf \
		$(use_with ftdi) --with-sdl \
		--with-png --without-bfd \
		--disable-static
}

src_install() {
	emake DESTDIR="${D}" install
	find "${D}" -name '*.la' -type f -delete || die
}
