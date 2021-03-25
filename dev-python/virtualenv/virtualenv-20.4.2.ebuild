# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} pypy3 )
DISTUTILS_USE_SETUPTOOLS=manual

inherit distutils-r1

DESCRIPTION="Virtual Python Environment builder"
HOMEPAGE="
	https://virtualenv.pypa.io/en/stable/
	https://pypi.org/project/virtualenv/
	https://github.com/pypa/virtualenv/
"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/appdirs-1.4.3[${PYTHON_USEDEP}]
	>=dev-python/distlib-0.3.1[${PYTHON_USEDEP}]
	>=dev-python/filelock-3[${PYTHON_USEDEP}]
	>=dev-python/setuptools-41[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/importlib_metadata-0.12[${PYTHON_USEDEP}]
	' python3_{6,7} pypy3)
	$(python_gen_cond_dep '
		>=dev-python/importlib_resources-1.0[${PYTHON_USEDEP}]
	' python3_6 pypy3)"
# coverage is used somehow magically in virtualenv, maybe it actually
# tests something useful
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		$(python_gen_cond_dep '
			dev-python/coverage[${PYTHON_USEDEP}]
			dev-python/flaky[${PYTHON_USEDEP}]
			>=dev-python/pip-20.0.2[${PYTHON_USEDEP}]
			>=dev-python/pytest-5[${PYTHON_USEDEP}]
			>=dev-python/pytest-freezegun-0.4.1[${PYTHON_USEDEP}]
			>=dev-python/pytest-mock-2.0.0[${PYTHON_USEDEP}]
			>=dev-python/pytest-timeout-1.3.4[${PYTHON_USEDEP}]
			dev-python/wheel[${PYTHON_USEDEP}]
			>=dev-python/packaging-20.0[${PYTHON_USEDEP}]
		' 'python3*')
	)"

distutils_enable_sphinx docs \
	dev-python/sphinx_rtd_theme \
	dev-python/towncrier

src_configure() {
	export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
}

python_test() {
	local deselect=(
		tests/unit/activation/test_xonsh.py
		tests/unit/seed/embed/test_bootstrap_link_via_app_data.py::test_seed_link_via_app_data
		tests/unit/create/test_creator.py::test_cross_major
	)
	[[ ${EPYTHON} == pypy3 ]] && deselect+=(
		'tests/unit/create/test_creator.py::test_create_no_seed[root-pypy3-posix-copies-isolated]'
		'tests/unit/create/test_creator.py::test_create_no_seed[root-pypy3-posix-copies-global]'
		'tests/unit/create/test_creator.py::test_create_no_seed[venv-pypy3-posix-copies-isolated]'
		'tests/unit/create/test_creator.py::test_create_no_seed[venv-pypy3-posix-copies-global]'
		'tests/unit/create/test_creator.py::test_zip_importer_can_import_setuptools'
		'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[PyPy-3.7.9-64-bin-]'
		'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[PyPy-3.7.9--bin-]'
		'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[PyPy-3.7-64-bin-]'
		'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[PyPy-3.7--bin-]'
		'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[PyPy-3-64-bin-]'
		'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[PyPy-3--bin-]'
		'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[python-3.7.9-64-bin-]'
		'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[python-3.7.9--bin-]'
		'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[python-3.7-64-bin-]'
		'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[python-3.7--bin-]'
		'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[python-3-64-bin-]'
		'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[python-3--bin-]'
	)

	distutils_install_for_testing --via-root
	pytest -vv ${deselect[@]/#/--deselect } ||
		die "Tests fail with ${EPYTHON}"
}

pkg_postinst() {
	elog "Please note that while virtualenv package no longer supports"
	elog "Python 2.7, you can still create py2.7 virtualenvs via:"
	elog "  $ virtualenv -p 2.7 ..."
}
