# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ ${PV} = 9999 ]]; then
	ESVN_REPO_URI="https://svn.code.sf.net/p/dosbox/code-0/dosbox/trunk"
	inherit subversion
else
	SRC_URI="mirror://sourceforge/dosbox/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86"
fi

inherit autotools eutils

DESCRIPTION="DOS emulator"
HOMEPAGE="http://dosbox.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
IUSE="alsa debug hardened opengl"

DEPEND="alsa? ( media-libs/alsa-lib )
	opengl? ( virtual/glu virtual/opengl )
	debug? ( sys-libs/ncurses:0 )
	media-libs/libpng:0
	media-libs/libsdl[joystick,video,X]
	media-libs/sdl-net
	media-libs/sdl-sound"
RDEPEND=${DEPEND}

if [[ ${PV} = 9999 ]]; then
	S=${WORKDIR}/${PN}
fi

PATCHES=( "${FILESDIR}/${PN}-0.74-gcc46.patch" )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable alsa alsa-midi) \
		$(use_enable !hardened dynamic-core) \
		$(use_enable !hardened dynamic-x86) \
		$(use_enable debug) \
		$(use_enable opengl)
}

src_install() {
	default
	make_desktop_entry dosbox DOSBox /usr/share/pixmaps/dosbox.ico
	doicon src/dosbox.ico
}
