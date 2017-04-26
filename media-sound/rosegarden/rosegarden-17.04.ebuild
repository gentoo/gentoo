# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit cmake-utils eutils fdo-mime gnome2-utils

DESCRIPTION="MIDI and audio sequencer and notation editor"
HOMEPAGE="http://www.rosegardenmusic.com/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="lirc"

RDEPEND="
	dev-qt/qtgui:5
	dev-qt/qtcore:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	media-libs/ladspa-sdk:=
	x11-libs/libSM:=
	media-sound/jack-audio-connection-kit:=
	media-libs/alsa-lib:=
	>=media-libs/dssi-1.0.0:=
	media-libs/liblo:=
	media-libs/liblrdf:=
	sci-libs/fftw:3.0
	media-libs/libsamplerate:=
	media-libs/libsndfile:=
	sys-libs/zlib:=
	lirc? ( app-misc/lirc:= )"
DEPEND="${RDEPEND}
	dev-qt/qttest:5
	virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		"-DDISABLE_LIRC=$(usex lirc OFF ON)"
	)
	cmake-utils_src_configure
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
