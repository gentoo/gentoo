# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Python API to get song lyrics from LyricWikia"
HOMEPAGE="https://github.com/enricobacis/lyricwikia"
SRC_URI="https://github.com/enricobacis/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="test? ( dev-python/responses[${PYTHON_USEDEP}] )"

RDEPEND="
	dev-python/beautifulsoup4[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"

PATCHES="${FILESDIR}/${P}-skip-online-test.patch"

distutils_enable_tests pytest

python_prepare_all() {
	# do not depend on deprecated dep
	sed -i -e '/pytest-runner/d' setup.py || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all

	# rename the executable to avoid file conflict with net-im/lyrics-in-terminal
	find "${D}" -name 'lyrics' -execdir mv {} lyricwikia \; || die
}

pkg_postinst() {
	elog "Note that access to LyricWikia through this API (and products that use this API) should comply to the LyricWikia terms of use"
	elog ""
	elog "LyricWikia is now offline, this package is provided solely for the purpose of satisfying media-video/vidify's dependencies"
}
