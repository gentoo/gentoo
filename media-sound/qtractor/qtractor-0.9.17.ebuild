# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic qmake-utils xdg

DESCRIPTION="Audio/MIDI multi-track sequencer written in C++ with the Qt framework"
HOMEPAGE="https://qtractor.sourceforge.io"
SRC_URI="mirror://sourceforge/qtractor/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"

IUSE="aubio cpu_flags_x86_sse debug dssi libsamplerate mad osc rubberband vorbis zlib"

BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"
DEPEND="
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
	aubio? ( media-libs/aubio )
	dssi? ( media-libs/dssi )
	libsamplerate? ( media-libs/libsamplerate )
	mad? ( media-libs/libmad )
	osc? ( media-libs/liblo )
	rubberband? ( media-libs/rubberband )
	vorbis? ( media-libs/libvorbis )
	zlib? ( sys-libs/zlib )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-dont-compress-manpages.patch"
)

src_configure() {
	append-cxxflags -std=c++11
	econf \
		--enable-ladspa \
		--enable-liblilv \
		$(use_enable debug) \
		$(use_enable aubio libaubio) \
		$(use_enable dssi) \
		$(use_enable libsamplerate) \
		$(use_enable mad libmad) \
		$(use_enable osc liblo) \
		$(use_enable rubberband librubberband) \
		$(use_enable cpu_flags_x86_sse sse) \
		$(use_enable vorbis libvorbis) \
		$(use_enable zlib libz)

	eqmake5 ${PN}.pro -o ${PN}.mak
}
