# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson

DESCRIPTION="A ncurses client for the Music Player Daemon (MPD)"
HOMEPAGE="https://www.musicpd.org/clients/ncmpc/ https://github.com/MusicPlayerDaemon/ncmpc"
SRC_URI="http://www.musicpd.org/download/${PN}/${PV%.*}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="artist-screen chat-screen doc +help-screen key-screen lirc lyrics-screen mouse nls outputs-screen search-screen song-screen"

RDEPEND=">=dev-libs/glib-2.30:2
	>=media-libs/libmpdclient-2.9
	sys-libs/ncurses:0=[unicode]
	lirc? ( app-misc/lirc )"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig"

DOCS=( AUTHORS NEWS README.rst doc/config.sample doc/keys.sample )
PATCHES=(
	"${FILESDIR}/fix_enqueue_from_search.patch"
	"${FILESDIR}/fix_gcc_warning.patch"
	"${FILESDIR}/restore_progress_bar_in_colorless_mode.patch"
)

src_configure() {
	local emesonargs=(
		-Dcurses=ncursesw
		$(meson_use mouse)
		$(meson_use nls multibyte)
		$(meson_use nls locale)
		$(meson_use nls)
		$(meson_use lyrics-screen lyrics_screen)
		$(meson_use lirc)
		-Dtcp=true
		-Dasync_connect=true
		-Dmini=false
		$(meson_use help-screen help_screen)
		$(meson_use artist-screen artist_screen)
		$(meson_use search-screen search_screen)
		$(meson_use song-screen song_screen)
		$(meson_use key-screen key_screen)
		$(meson_use lyrics-screen lyrics_screen)
		$(meson_use outputs-screen outputs_screen)
		$(meson_use chat-screen chat_screen)
		$(meson_use doc documentation)
	)
	if use lyrics-screen; then
		emesonargs+=(
			-Dlyrics_plugin_dir="${EPREFIX}"/usr/$(get_libdir)/ncmpc/lyrics
		)
	fi

	meson_src_configure
}
