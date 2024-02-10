# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9,10,11} )
PYTHON_REQ_USE="sqlite"

inherit bash-completion-r1 distutils-r1

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

python_prepare_all() {
	# Remove support for bukuserver - complex depgraph which isn't all
	# sufficiently packaged in Gentoo
	sed -ie '/console_scripts/s/,.*/]/' setup.py || die
	sed -ie 's/.*bukuserver.*//' tests/test_views.py || die
	sed -ie 's/.*flask.*//' tests/test_views.py || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all

	insinto /usr/share/zsh/site-functions
	doins auto-completion/zsh/_*

	newbashcomp auto-completion/bash/buku-completion.bash "${PN}"

	doman buku.1
}

python_test() {
	local skipped_tests=(
		# Disable tests related to bukuserver
		tests/test_setup.py::test_bukuserver_requirement
		tests/test_views.py::test_bmv_create_form
		tests/test_views.py::test_bookmark_model_view
		tests/test_views.py::test_load_firefox_database
		tests/test_views.py::test_tag_model_view_get_list
		tests/test_views.py::test_tag_model_view_get_list_empty_db

		# Broken with network-sandbox
		tests/test_buku.py::test_network_handler_with_url
		tests/test_bukuDb.py::TestBukuDb::test_tnyfy_url
		tests/test_bukuDb.py::test_add_rec_exec_arg
		tests/test_bukuDb.py::test_load_firefox
		tests/test_bukuDb.py::test_print_db
		tests/test_bukuDb.py::test_print_rec
		tests/test_bukuDb.py::test_refreshdb

		# Hard to debug sandbox issue - these pass when run outside portage
		# There also appears to be some state issue between these, because
		# skipping one can result in a later one failing.
		tests/test_bukuDb.py::test_delete_rec_index_and_delay_commit[1-True-False]
		tests/test_bukuDb.py::test_delete_rec_index_and_delay_commit[1-False-True]
		tests/test_bukuDb.py::test_delete_rec_index_and_delay_commit[1-False-False]
		tests/test_bukuDb.py::test_delete_rec_index_and_delay_commit[1-True-True]
	)

	# tests/test_server.py is bukuserver tests, ignore it
	pytest -p no:verbose-parametrize -v --ignore tests/test_server.py ${skipped_tests[@]/#/--deselect } || die "Tests failed with ${EPYTHON}"
}
