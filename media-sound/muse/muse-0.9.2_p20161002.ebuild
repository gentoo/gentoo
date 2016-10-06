# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="Multiple Streaming Engine, an icecast source streamer"
HOMEPAGE="http://muse.dyne.org"
SRC_URI="https://dev.gentoo.org/~soap/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="doc gtk jack ncurses portaudio"

RDEPEND="media-sound/lame
	media-libs/libvorbis
	media-libs/libsndfile
	media-libs/libogg
	media-libs/libshout
	media-libs/libsamplerate
	gtk? ( x11-libs/gtk+:2 )
	jack? ( media-sound/jack-audio-connection-kit )
	ncurses? ( sys-libs/ncurses:0= )
	portaudio? ( media-libs/portaudio )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.2_p20161002-fix-build-system.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--without-dmalloc \
		--disable-profiling \
		--disable-lubrify \
		$(use_enable gtk gtk2) \
		$(use_enable jack) \
		$(use_enable ncurses) \
		$(use_enable portaudio) \
		$(use_enable doc)
}
