# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils fdo-mime

DESCRIPTION="A music notation editor"
HOMEPAGE="http://www.denemo.org/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3 OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa jack +fluidsynth nls +portaudio portmidi"

COMMON_DEPEND="
	>=app-text/evince-3
	dev-libs/libxml2:2
	>=dev-scheme/guile-1.8
	gnome-base/librsvg:2
	media-libs/fontconfig:1.0
	>=media-libs/libsmf-1.3
	media-libs/libsndfile
	x11-libs/gtk+:3
	x11-libs/gtksourceview:3.0
	alsa? ( media-libs/alsa-lib )
	jack? ( >=media-sound/jack-audio-connection-kit-0.102 )
	fluidsynth? ( media-sound/fluidsynth )
	portaudio? (
		media-libs/portaudio
		media-libs/aubio
		sci-libs/fftw:3.0
		media-libs/libsamplerate
	)
	portmidi? ( media-libs/portmidi )"
RDEPEND="${COMMON_DEPEND}
	media-sound/lilypond"
DEPEND="${COMMON_DEPEND}
	sys-devel/flex
	virtual/pkgconfig
	virtual/yacc
	nls? ( sys-devel/gettext )"

DOCS=( AUTHORS ChangeLog doc/{DESIGN{,.lilypond},GOALS,TODO} NEWS )

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.9.6-desktop.patch
}

src_configure() {
	econf \
		--disable-static \
		--enable-gtk3 \
		$(use_enable alsa) \
		$(use_enable fluidsynth) \
		$(use_enable jack) \
		$(use_enable nls) \
		$(use_enable portaudio) \
		$(use_enable portmidi) \
		--enable-x11
}

pkg_postinst() { fdo-mime_desktop_database_update; }
pkg_postrm() { fdo-mime_desktop_database_update; }
