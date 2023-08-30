# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1

DESCRIPTION="Python scrapper to access ModDB mods, games and more as objects"
HOMEPAGE="https://github.com/ClementJ18/moddb"
SRC_URI="https://github.com/ClementJ18/moddb/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Connects to moddb.com
PROPERTIES="test_network"
RESTRICT="test"

RDEPEND="
	dev-python/beautifulsoup4[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/toolz[${PYTHON_USEDEP}]
	<dev-python/pyrate-limiter-3.0[${PYTHON_USEDEP}]
"

BDEPEND="test? (
	dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
)"

EPYTEST_DESELECT=(
	# These tests require valid moddb.com login information
	"tests/test_base.py::TestLogin::test_login"
	"tests/test_client.py::TestClient::test_get_watched"
	"tests/test_client.py::TestClient::test_get_updates"
	"tests/test_client.py::TestClient::test_posts"
	"tests/test_client.py::TestClient::test_friends"
	"tests/test_client.py::TestClient::test_messages"
)

distutils_enable_sphinx docs/source dev-python/sphinx-autodoc-typehints
distutils_enable_tests pytest

python_test() {
	# Dummy moddb.com login information
	export USERNAME="portage"
	export SENDER_USERNAME="portage"
	export PASSWORD="testing"
	export SENDER_PASSWORD="testing"
	epytest
}
