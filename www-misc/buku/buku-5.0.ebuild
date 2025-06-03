# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1 shell-completion

DESCRIPTION="Powerful command-line bookmark manager"
HOMEPAGE="https://github.com/jarun/buku"
SRC_URI="https://github.com/jarun/${PN}/archive/v$(ver_cut 1-2).tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/beautifulsoup4-4.6.0[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	>=dev-python/html5lib-1.0.1[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		dev-python/attrs[${PYTHON_USEDEP}]
		>=dev-python/click-7.0[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
		>=dev-python/py-1.5.0[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-4.2[${PYTHON_USEDEP}]
		>=dev-python/vcrpy-4.0.2[${PYTHON_USEDEP}]
	)
"

EPYTEST_IGNORE=(
	# bukuserver tests
	tests/test_views.py
	tests/test_server.py
)

EPYTEST_DESELECT=(
	# Broken with network-sandbox
	tests/test_buku.py::test_network_handler_with_url
	tests/test_buku.py::test_fetch_data_with_url
	tests/test_bukuDb.py::TestBukuDb::test_tnyfy_url
	tests/test_bukuDb.py::test_add_rec_exec_arg
	tests/test_bukuDb.py::test_load_firefox
	tests/test_bukuDb.py::test_print_db
	tests/test_bukuDb.py::test_print_rec
	tests/test_bukuDb.py::test_refreshdb
)

distutils_enable_tests pytest

python_prepare_all() {
	# Remove support for bukuserver - complex depgraph which isn't all
	# sufficiently packaged in Gentoo
	sed -ie '/console_scripts/s/,.*/]/' setup.py || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all

	newbashcomp auto-completion/bash/buku-completion.bash "${PN}"
	newzshcomp auto-completion/zsh/_buku _buku
	newfishcomp auto-completion/fish/buku.fish buku.fish

	doman buku.1
}
