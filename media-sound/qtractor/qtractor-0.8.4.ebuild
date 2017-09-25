# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic qmake-utils

DESCRIPTION="Audio/MIDI multi-track sequencer written in C++ with the Qt framework"
HOMEPAGE="http://qtractor.sourceforge.net/"
SRC_URI="mirror://sourceforge/qtractor/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="cpu_flags_x86_sse debug dssi libsamplerate mad osc +qt5 rubberband vorbis zlib"

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
		dev-qt/qtx11extras:5
	)
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
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	qt5? ( dev-qt/linguist-tools:5 )"

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
		$(use_enable !qt5 qt4) \
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
