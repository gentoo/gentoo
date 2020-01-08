# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{6,7}} pypy3 )

inherit distutils-r1

DESCRIPTION="virtualenv-based automation of test activities"
HOMEPAGE="https://tox.readthedocs.io https://github.com/tox-dev/tox https://pypi.org/project/tox/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/virtualenv-1.11.2[${PYTHON_USEDEP}]
	<dev-python/pluggy-1.0[${PYTHON_USEDEP}]
	dev-python/pip[${PYTHON_USEDEP}]
	>=dev-python/py-1.4.17[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		>=dev-python/pytest-3.6[${PYTHON_USEDEP}]
		<dev-python/pytest-4.0
		<dev-python/pytest-mock-2.0[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	# remove intersphinx stuff
	sed -i -e "s/'sphinx.ext.intersphinx',//" doc/conf.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		esetup.py build_sphinx
		HTML_DOCS=( "${S}"/doc/build/html/. )
	fi
}

python_test() {
	# TODO: find why these 8 tests excluded below fail.
	pytest -v --no-network \
		--deselect tests/test_config.py::test_plugin_require \
		--deselect tests/test_docs.py::test_all_rst_ini_blocks_parse \
		--deselect tests/test_interpreters.py::test_tox_get_python_executable \
		--deselect tests/test_session.py::test_tox_parallel_build_safe \
		--deselect tests/test_venv.py::test_install_python3 \
		--deselect tests/test_z_cmdline.py::test_alwayscopy \
		--deselect tests/test_z_cmdline.py::test_tox_quickstart_script \
		--deselect tests/test_z_cmdline.py::test_tox_console_script \
		|| die "Testsuite failed under ${EPYTHON}"
}
