# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop flag-o-matic

MY_P=${PN}-$(ver_rs 2 -)

DESCRIPTION="DOS emulator"
HOMEPAGE="https://www.dosbox.com/"
SRC_URI="mirror://sourceforge/dosbox/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86"
IUSE="alsa +core-inline debug hardened opengl X"

RDEPEND="alsa? ( media-libs/alsa-lib )
	opengl? ( virtual/glu virtual/opengl )
	debug? ( sys-libs/ncurses:0 )
	X? ( x11-libs/libX11 )
	media-libs/libpng:0=
	media-libs/libsdl[joystick,opengl?,video,X?]
	media-libs/sdl-net
	media-libs/sdl-sound
	sys-libs/zlib"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${P}_events.patch"
)

src_configure() {
	ac_cv_lib_X11_main=$(usex X yes no) \
	econf \
		$(use_enable alsa alsa-midi) \
		$(use_enable core-inline) \
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
