# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A ncurses client for the Music Player Daemon (MPD)"
HOMEPAGE="https://www.musicpd.org/clients/ncmpc/ https://github.com/MusicPlayerDaemon/ncmpc"
SRC_URI="http://www.musicpd.org/download/${PN}/${PV%.*}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="artist-screen chat-screen colors debug +help-screen key-screen lirc lyrics-screen mouse nls search-screen song-screen"

RDEPEND=">=dev-libs/glib-2.30:2
	>=media-libs/libmpdclient-2.9
	sys-libs/ncurses:0=[unicode]
	lirc? ( app-misc/lirc )"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig"

DOCS=( AUTHORS NEWS README doc/config.sample doc/keys.sample )

src_configure() {
	# upstream lirc doesn't have pkg-config file wrt #250015
	if use lirc; then
		export LIBLIRCCLIENT_CFLAGS="-I/usr/include/lirc"
		export LIBLIRCCLIENT_LIBS="-llirc_client"
	fi

	# use_with lyrics-screen is for multilib
	econf \
		--docdir=/usr/share/doc/${PF} \
		--with-ncursesw \
		$(use_enable artist-screen) \
		$(use_enable chat-screen) \
		$(use_enable colors) \
		$(use_enable debug) \
		$(use_enable help-screen) \
		$(use_enable key-screen) \
		$(use_enable lirc) \
		$(use_enable lyrics-screen) \
		$(use_enable mouse) \
		$(use_enable nls locale) \
		$(use_enable nls multibyte) \
		$(use_enable nls) \
		$(use_enable search-screen) \
		$(use_enable song-screen) \
		$(use_with lyrics-screen lyrics-plugin-dir /usr/$(get_libdir)/ncmpc/lyrics)
}
