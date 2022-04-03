# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit bash-completion-r1 distutils-r1

DESCRIPTION="Simple app to get songs from youtube in mp3 format"
HOMEPAGE="https://ytmdl.deepjyoti30.dev/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=net-misc/yt-dlp-2022.3.8.2[${PYTHON_USEDEP}]
	dev-python/PySocks[${PYTHON_USEDEP}]
	dev-python/beautifulsoup4[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/ffmpeg-python[${PYTHON_USEDEP}]
	dev-python/itunespy[${PYTHON_USEDEP}]
	dev-python/pyDes[${PYTHON_USEDEP}]
	dev-python/python-musicbrainzngs[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	dev-python/simber[${PYTHON_USEDEP}]
	dev-python/spotipy[${PYTHON_USEDEP}]
	dev-python/unidecode[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]
	dev-python/youtube-search-python[${PYTHON_USEDEP}]
	dev-python/ytmusicapi[${PYTHON_USEDEP}]
	media-libs/mutagen[${PYTHON_USEDEP}]
	net-misc/downloader-cli[${PYTHON_USEDEP}]
"

PATCHES=( "${FILESDIR}"/${P}-setup.py-beautifulsoup4.patch )

src_install() {
	distutils-r1_src_install

	newbashcomp ${PN}.bash ${PN}
}
