# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils autotools

DESCRIPTION="The Umiquious Amiga Emulator"
HOMEPAGE="http://www.amigaemulator.org/"
SRC_URI="ftp://ftp.amigaemulator.org/pub/uae/sources/develop/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="sdl alsa scsi"

DEPEND="sdl? ( media-libs/libsdl
		   media-libs/sdl-gfx
		   x11-libs/gtk+:2
		   alsa? ( media-libs/alsa-lib )
	)
	!sdl? ( x11-libs/libXext
		 x11-libs/gtk+:2
	)
	alsa? ( media-libs/alsa-lib )
	scsi? ( app-cdr/cdrtools )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.8.25-allow_spaces_in_zip_filenames.diff
	epatch "${FILESDIR}"/${PN}-0.8.25-struct_uae_wrong_fields_name.diff
	epatch "${FILESDIR}"/${PN}-0.8.26-uae_reset_args.diff
	epatch "${FILESDIR}"/${PN}-0.8.26-underlinking.patch

	cp "${FILESDIR}"/sdlgfx.h "${S}"/src || die

	eautoreconf
}

src_configure() {
	# disabling lots of options, cause many code-paths are broken, these should compile,
	# if you want/need other options, please test if they work with other combinations
	# before opening a bug
	econf --enable-ui --with-x --without-svgalib \
		--without-asciiart --without-sdl-sound --enable-threads \
		$(use_with sdl) $(use_with sdl sdl-gfx) \
		$(use_with alsa) \
		$(use_enable scsi scsi-device)
}

src_compile() {
	emake -j1
}

src_install() {
	dobin uae readdisk
	cp docs/unix/README docs/README.unix || die
	rm -r docs/{AmigaOS,BeOS,pOS,translated,unix} || die
	dodoc docs/*

	insinto /usr/share/uae/amiga-tools
	doins amiga/{*hack,trans*,uae*}
}

pkg_postinst() {
	elog
	elog "Upstream recommends using SDL graphics (with an environment variable)"
	elog "SDL_VIDEO_X11_XRANDR=1 for fullscreen support."
	echo
}
