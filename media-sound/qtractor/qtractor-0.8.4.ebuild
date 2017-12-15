# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic qmake-utils

DESCRIPTION="Audio/MIDI multi-track sequencer written in C++ with the Qt framework"
HOMEPAGE="https://qtractor.sourceforge.io"
SRC_URI="mirror://sourceforge/qtractor/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="cpu_flags_x86_sse debug dssi libsamplerate mad osc rubberband vorbis zlib"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	dev-qt/qtx11extras:5
	media-libs/alsa-lib
	media-libs/ladspa-sdk
	media-libs/libsndfile
	>=media-libs/lilv-0.16.0
	media-libs/lv2
	media-libs/suil
	virtual/jack
	dssi? ( media-libs/dssi )
	libsamplerate? ( media-libs/libsamplerate )
	mad? ( media-libs/libmad )
	osc? ( media-libs/liblo )
	rubberband? ( media-libs/rubberband )
	vorbis? ( media-libs/libvorbis )
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"

DOCS=( README ChangeLog TODO AUTHORS )

src_configure() {
	append-cxxflags '-std=c++11'
	econf \
		$(use_enable mad libmad) \
		$(use_enable libsamplerate) \
		$(use_enable vorbis libvorbis) \
		$(use_enable osc liblo) \
		--enable-ladspa \
		$(use_enable dssi) \
		--enable-lilv \
		--disable-qt4 \
		--with-qt5=$(qt5_get_libdir)/qt5 \
		$(use_enable rubberband librubberband) \
		$(use_enable cpu_flags_x86_sse sse) \
		$(use_enable zlib libz) \
		$(use_enable debug)

	eqmake5 ${PN}.pro -o ${PN}.mak
}
