# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qmake-utils flag-o-matic eutils

DESCRIPTION="Qtractor is an Audio/MIDI multi-track sequencer"
HOMEPAGE="http://qtractor.sourceforge.net/"
SRC_URI="mirror://sourceforge/qtractor/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="debug dssi libsamplerate mad osc qt5 rubberband vorbis cpu_flags_x86_sse zlib"

RDEPEND="
	!qt5? (
		>=dev-qt/qtcore-4.2:4
		>=dev-qt/qtgui-4.7:4
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
	)
	media-libs/alsa-lib
	media-libs/libsndfile
	media-sound/jack-audio-connection-kit
	media-libs/ladspa-sdk
	>=media-libs/lilv-0.16.0
	media-libs/lv2
	media-libs/suil
	dssi? ( media-libs/dssi )
	mad? ( media-libs/libmad )
	libsamplerate? ( media-libs/libsamplerate )
	osc? ( media-libs/liblo )
	rubberband? ( media-libs/rubberband )
	vorbis? ( media-libs/libvorbis )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="README ChangeLog TODO AUTHORS"

src_prepare() {
	epatch "${FILESDIR}"/${P}-qt55-includes.patch
}

src_configure() {
	econf \
		$(use_enable mad libmad) \
		$(use_enable libsamplerate) \
		$(use_enable vorbis libvorbis) \
		$(use_enable osc liblo) \
		--enable-ladspa \
		$(use_enable dssi) \
		--enable-lilv \
		$(use_enable qt5) \
		$(use_with qt5 qt5 "$(qt5_get_libdir)/qt5") \
		$(use_enable rubberband librubberband) \
		$(use_enable cpu_flags_x86_sse sse) \
		$(use_enable zlib libz) \
		$(use_enable debug)

	if use qt5 ; then
		eqmake5 ${PN}.pro -o ${PN}.mak
	else
		eqmake4 ${PN}.pro -o ${PN}.mak
	fi
}

src_install() {
	emake DESTDIR="${D}" install
	einstalldocs
}
