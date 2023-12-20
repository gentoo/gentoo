# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 multiprocessing pypi

DESCRIPTION="Virtual Python Environment builder"
HOMEPAGE="
	https://virtualenv.pypa.io/en/stable/
	https://pypi.org/project/virtualenv/
	https://github.com/pypa/virtualenv/
"

LICENSE="MIT"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
SLOT="0"

RDEPEND="
	>=dev-python/distlib-0.3.7[${PYTHON_USEDEP}]
	>=dev-python/filelock-3.12.2[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-3.9.1[${PYTHON_USEDEP}]
"
# coverage is used somehow magically in virtualenv, maybe it actually
# tests something useful
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/flaky[${PYTHON_USEDEP}]
		>=dev-python/pip-22.2.1[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			>=dev-python/pytest-freezer-0.4.6[${PYTHON_USEDEP}]
		' pypy3)
		>=dev-python/pytest-mock-3.6.1[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		>=dev-python/setuptools-67.8[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/time-machine[${PYTHON_USEDEP}]
		' 'python3*')
		dev-python/wheel[${PYTHON_USEDEP}]
		>=dev-python/packaging-20.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	# workaround test failures due to warnings from setuptools-scm, sigh
	echo '[tool.setuptools_scm]' >> pyproject.toml || die

	# remove useless pins
	sed -i -e 's:<[0-9.]*,::' pyproject.toml || die

	distutils-r1_src_prepare
}

python_test() {
	local EPYTEST_DESELECT=(
		tests/unit/activation/test_xonsh.py
		tests/unit/seed/embed/test_bootstrap_link_via_app_data.py::test_seed_link_via_app_data
		tests/unit/create/test_creator.py::test_cross_major
		# tests failing without python2 installed
		"tests/unit/create/test_creator.py::test_py_pyc_missing[True-False]"
		"tests/unit/create/test_creator.py::test_py_pyc_missing[False-False]"
	)
	case ${EPYTHON} in
		pypy3)
			EPYTEST_DESELECT+=(
				'tests/unit/create/test_creator.py::test_create_no_seed[root-pypy3-posix-copies-isolated]'
				'tests/unit/create/test_creator.py::test_create_no_seed[root-pypy3-posix-copies-global]'
				'tests/unit/create/test_creator.py::test_create_no_seed[venv-pypy3-posix-copies-isolated]'
				'tests/unit/create/test_creator.py::test_create_no_seed[venv-pypy3-posix-copies-global]'
				'tests/unit/create/test_creator.py::test_create_no_seed[root-venv-copies-isolated]'
				'tests/unit/create/test_creator.py::test_create_no_seed[root-venv-copies-global]'
				'tests/unit/create/test_creator.py::test_create_no_seed[venv-venv-copies-isolated]'
				'tests/unit/create/test_creator.py::test_create_no_seed[venv-venv-copies-global]'
				'tests/unit/create/test_creator.py::test_zip_importer_can_import_setuptools'
				'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[PyPy-3.7.9-64-bin-]'
				'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[PyPy-3.7.9--bin-]'
				'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[PyPy-3.7.10-64-bin-]'
				'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[PyPy-3.7.10--bin-]'
				'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[PyPy-3.7-64-bin-]'
				'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[PyPy-3.7--bin-]'
				'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[PyPy-3-64-bin-]'
				'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[PyPy-3--bin-]'
				'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[python-3.7.9-64-bin-]'
				'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[python-3.7.9--bin-]'
				'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[python-3.7.10-64-bin-]'
				'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[python-3.7.10--bin-]'
				'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[python-3.7-64-bin-]'
				'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[python-3.7--bin-]'
				'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[python-3-64-bin-]'
				'tests/unit/discovery/py_info/test_py_info_exe_based_of.py::test_discover_ok[python-3--bin-]'
			)
			;;
		python3.12)
			EPYTEST_DESELECT+=(
				tests/unit/create/via_global_ref/test_build_c_ext.py
			)
			;&
		python3.11)
			EPYTEST_DESELECT+=(
				# TODO
				tests/unit/discovery/py_info/test_py_info.py::test_fallback_existent_system_executable
			)
			;;
	esac

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x TZ=UTC
	local plugins=( -p flaky -p pytest_mock )
	if [[ ${EPYTHON} == pypy3 ]]; then
		plugins+=( -p freezegun )
	else
		plugins+=( -p time_machine )
	fi
	epytest "${plugins[@]}" -p xdist -n "$(makeopts_jobs)" --dist=worksteal
}
