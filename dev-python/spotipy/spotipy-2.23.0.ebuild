# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

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
KEYWORDS="amd64 ~x86"
SLOT="0"
IUSE="examples"

RDEPEND="
	dev-python/redis[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Internet
	tests/unit/test_oauth.py::TestSpotifyClientCredentials::test_spotify_client_credentials_get_access_token
)

python_install_all() {
	distutils-r1_python_install_all

	use examples && dodoc -r examples
}
