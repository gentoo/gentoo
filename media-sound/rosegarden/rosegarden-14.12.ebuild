# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/rosegarden/rosegarden-14.12.ebuild,v 1.1 2015/01/04 05:21:56 radhermit Exp $

EAPI=5
inherit autotools eutils fdo-mime gnome2-utils multilib

DESCRIPTION="MIDI and audio sequencer and notation editor"
HOMEPAGE="http://www.rosegardenmusic.com/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug lirc"

RDEPEND="dev-qt/qtgui:4
	media-libs/ladspa-sdk:=
	x11-libs/libSM:=
	media-sound/jack-audio-connection-kit:=
	media-libs/alsa-lib:=
	>=media-libs/dssi-1.0.0:=
	media-libs/liblo:=
	media-libs/liblrdf:=
	sci-libs/fftw:3.0
	media-libs/libsamplerate:=[sndfile]
	lirc? ( app-misc/lirc:= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-misc/makedepend"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-12.12.25-debug.patch
	eautoreconf
}

src_configure() {
	export USER_CXXFLAGS="${CXXFLAGS}"

	export ac_cv_header_lirc_lirc_client_h=$(usex lirc)
	export ac_cv_lib_lirc_client_lirc_init=$(usex lirc)

	econf \
		$(use_enable debug) \
		--with-qtdir=/usr \
		--with-qtlibdir=/usr/$(get_libdir)/qt4
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
