# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 xdg-utils desktop

DESCRIPTION="Show Youtube music videos and lyrics for the currently playing Spotify song"
HOMEPAGE="https://github.com/marioortizmanero/spotify-music-videos"
SRC_URI="https://github.com/marioortizmanero/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/pydbus[${PYTHON_USEDEP}]
	dev-python/lyricwikia[${PYTHON_USEDEP}]
	dev-python/python-vlc[${PYTHON_USEDEP}]
	net-misc/youtube-dl[${PYTHON_USEDEP}]
	media-sound/spotify"

distutils_enable_tests pytest

python_install_all() {
	distutils-r1_python_install_all
	make_desktop_entry spotify-videos "Spotify Music Videos" spotify-linux-64 "AudioVideo;Music" Terminal=true
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update

	elog '"spotify-videos --debug" might complain about missing codecs, if this happens please recompile media-video/vlc with the proper codecs'
	elog 'Pro-tip: Create a special profile for your terminal emulator with a nice lyric-font. then edit the .desktop entry and add TerminalOptions=--profile name-of-profile'
	elog 'Or launch spotify-videos directly in a terminal with the correct profile, e.g for konsole: "konsole --profile name-of=profile -e spotify-videos"'
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
