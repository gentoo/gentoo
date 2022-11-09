# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Ncurses client for the Music Player Daemon (MPD)"
HOMEPAGE="https://www.musicpd.org/clients/ncmpc/ https://github.com/MusicPlayerDaemon/ncmpc"
SRC_URI="https://www.musicpd.org/download/${PN}/${PV%.*}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 ~sparc x86"
IUSE="async-connect chat-screen doc +help-screen key-screen +library-screen lirc lyrics-screen +mouse nls outputs-screen pcre search-screen +song-screen"

BDEPEND="
	virtual/pkgconfig
	doc? ( dev-python/sphinx )
"
RDEPEND="
	media-libs/libmpdclient
	sys-libs/ncurses:=[unicode(+)]
	lirc? ( app-misc/lirc )
	pcre? ( dev-libs/libpcre2 )
"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	# use correct docdir and don't install license file
	sed -e "/^docdir =/s/meson.project_name()/'${PF}'/" \
		-e "s/'COPYING', //" \
		-i meson.build || die

	# use correct (html) docdir
	sed -e "/install_dir:.*doc/s/meson.project_name()/'${PF}'/" \
		-i doc/meson.build || die
}

src_configure() {
	local emesonargs=(
		-Dcurses=ncursesw
		-Dcolors=true
		-Dmini=false
		-Dlyrics_plugin_dir="${EPREFIX}/usr/$(get_libdir)/ncmpc/lyrics"
		-Dasync_connect=$(usex async-connect true false)
		-Dchat_screen=$(usex chat-screen true false)
		-Ddocumentation=$(usex doc enabled disabled)
		-Dhelp_screen=$(usex help-screen true false)
		-Dkey_screen=$(usex key-screen true false)
		-Dlibrary_screen=$(usex library-screen true false)
		-Dlirc=$(usex lirc enabled disabled)
		-Dlocale=$(usex nls enabled disabled)
		-Dlyrics_screen=$(usex lyrics-screen true false)
		-Dmouse=$(usex mouse enabled disabled)
		-Dmultibyte=$(usex nls true false)
		-Dnls=$(usex nls enabled disabled)
		-Doutputs_screen=$(usex outputs-screen true false)
		-Dregex=$(usex pcre enabled disabled)
		-Dsearch_screen=$(usex search-screen true false)
		-Dsong_screen=$(usex song-screen true false)
	)

	meson_src_configure
}
