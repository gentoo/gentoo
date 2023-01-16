# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="A light weight Python library for the Spotify Web API"
HOMEPAGE="https://spotipy.readthedocs.io"
SRC_URI="https://github.com/plamere/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="examples"

RDEPEND="
	dev-python/redis-py[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]
"
BDEPEND="test? ( dev-python/mock[${PYTHON_USEDEP}] )"

distutils_enable_sphinx docs
distutils_enable_tests pytest

python_prepare_all() {
	# Needs internet access
	sed -i -e 's:test_spotify_client_credentials_get_access_token:_&:' \
		tests/unit/test_oauth.py || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all

	use examples && dodoc -r examples
}
