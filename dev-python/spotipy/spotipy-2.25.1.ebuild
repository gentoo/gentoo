# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="A lightweight Python library for the Spotify Web API"
HOMEPAGE="
	https://spotipy.readthedocs.io/
	https://github.com/spotipy-dev/spotipy/
	https://pypi.org/project/spotipy/
"
SRC_URI="
	https://github.com/spotipy-dev/spotipy/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="
	dev-python/redis[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs \
	dev-python/redis \
	dev-python/sphinx-rtd-theme
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Internet
	tests/unit/test_oauth.py::TestSpotifyClientCredentials::test_spotify_client_credentials_get_access_token
)

python_install_all() {
	distutils-r1_python_install_all

	use examples && dodoc -r examples
}
