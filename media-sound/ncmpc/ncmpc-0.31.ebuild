# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson

DESCRIPTION="A ncurses client for the Music Player Daemon (MPD)"
HOMEPAGE="https://www.musicpd.org/clients/ncmpc/ https://github.com/MusicPlayerDaemon/ncmpc"
SRC_URI="http://www.musicpd.org/download/${PN}/${PV%.*}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc ppc64 ~sparc x86"
IUSE="+artist-screen async-connect chat-screen doc +help-screen key-screen lirc lyrics-screen outputs-screen search-screen +song-screen +mouse nls tcp"

RDEPEND="
	dev-libs/glib:2
	media-libs/libmpdclient
	sys-libs/ncurses:0=[unicode]
	lirc? ( app-misc/lirc )
"

DEPEND="
	${RDEPEND}
	doc? (
		app-doc/doxygen
		dev-python/sphinx
	)
	virtual/pkgconfig
"

DOCS=( doc/. AUTHORS README.rst )

src_prepare() {
	default
	sed -i -e '/'-Wl,--gc-sections'./d' meson.build || die "sed failed"
}

src_configure() {
	local emesonargs=(
		-Dcurses=ncursesw
		-Dcolors=true
		-Dmini=false
		-Dlyrics_plugin_dir="${EPREFIX}/usr/$(get_libdir)/ncmpc/lyrics"
		-Dartist_screen=$(usex artist-screen true false)
		-Dasync_connect=$(usex async-connect true false)
		-Dchat_screen=$(usex chat-screen true false)
		-Ddocumentation=$(usex doc true false)
		-Dhelp_screen=$(usex help-screen true false)
		-Dkey_screen=$(usex key-screen true false)
		-Dlyrics_screen=$(usex lyrics-screen true false)
		-Doutputs_screen=$(usex outputs-screen true false)
		-Dsearch_screen=$(usex search-screen true false)
		-Dsong_screen=$(usex song-screen true false)
		-Dlocale=$(usex nls true false)
		-Dmultibyte=$(usex nls true false)
		-Dnls=$(usex nls true false)
		-Dlirc=$(usex lirc true false)
		-Dmouse=$(usex mouse true false)
		-Dtcp=$(usex tcp true false)
		)
	meson_src_configure
}
