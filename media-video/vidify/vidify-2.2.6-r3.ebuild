# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
inherit xdg distutils-r1 optfeature virtualx

DESCRIPTION="Watch music videos in real time for the songs playing on your device"
HOMEPAGE="https://vidify.org"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"

IUSE="dbus vlc mpv zeroconf"

REQUIRED_USE="|| ( vlc mpv zeroconf )"

RDEPEND="
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/QtPy[gui,webengine,${PYTHON_USEDEP}]
	net-misc/lyricwikia[${PYTHON_USEDEP}]
	net-misc/yt-dlp[${PYTHON_USEDEP}]
	dbus? ( dev-python/pydbus[${PYTHON_USEDEP}] )
	!dbus? ( dev-python/tekore[${PYTHON_USEDEP}] )
	mpv? ( dev-python/python-mpv[${PYTHON_USEDEP}] )
	vlc? ( dev-python/python-vlc[${PYTHON_USEDEP}] )
	zeroconf? ( dev-python/python-zeroconf[${PYTHON_USEDEP}] )
"

# use yt-dlp instead of youtube-dl, otherwise download is too slow for playback
PATCHES=(
	"${FILESDIR}/${P}-yt-dlp.patch"
	"${FILESDIR}/${P}-python310.patch"
)

distutils_enable_tests unittest

python_prepare_all() {
	# skip online test
	rm tests/api/test_spotify_web.py || die
	rm tests/player/test_external.py || die

	# this needs dbus and a player running
	rm tests/api/test_mpris.py || die

	# can't parse non-existent config
	rm tests/test_api_and_player_data.py || die

	# do not hard depend on this
	sed -i \
		-e '/qdarkstyle/d' \
		-e '/python-vlc/d' \
		-e '/python-mpv/d' \
		-e '/pydbus/d' \
		-e '/tekore/d' \
		-e '/zeroconf/d' \
		-e '/If PySide2 is installed and PyQt5/,/PyQtWebEngine/d' \
		setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	virtx "${EPYTHON}" -m unittest discover -v
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "If video playback is not working please check 'vidify --debug' for missing-codec-errors"
	elog "and recompile media-video/vlc or media-video/mpv with the missing codecs"

	optfeature "using an MPRIS(D-Bus) audio player (e.g spotify)" dev-python/pydbus
	optfeature "using the Spotify Web API as audio player" dev-python/tekore
	optfeature "using an external network player" dev-python/zeroconf
	optfeature "using media-video/mpv for video playback" dev-python/python-mpv
	optfeature "using media-video/vlc for video playback" dev-python/python-vlc
	optfeature "'vidify --dark-mode'" dev-python/qdarkstyle
	optfeature "'vidify --audiosync'" media-video/vidify-audiosync
}
