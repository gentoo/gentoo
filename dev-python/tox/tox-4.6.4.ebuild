# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="virtualenv-based automation of test activities"
HOMEPAGE="
	https://tox.readthedocs.io/
	https://github.com/tox-dev/tox/
	https://pypi.org/project/tox/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	>=dev-python/cachetools-5.3.1[${PYTHON_USEDEP}]
	>=dev-python/chardet-5.1[${PYTHON_USEDEP}]
	>=dev-python/colorama-0.4.6[${PYTHON_USEDEP}]
	>=dev-python/filelock-3.12.2[${PYTHON_USEDEP}]
	>=dev-python/packaging-23.1[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-3.8[${PYTHON_USEDEP}]
	>=dev-python/pluggy-1.2[${PYTHON_USEDEP}]
	>=dev-python/pyproject-api-1.5.2[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/tomli-2.0.1[${PYTHON_USEDEP}]
	' 3.{9..10})
	>=dev-python/virtualenv-20.23.1[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/hatch-vcs-0.3[${PYTHON_USEDEP}]
	test? (
		>=dev-python/build-0.10[${PYTHON_USEDEP}]
		>=dev-python/distlib-0.3.6[${PYTHON_USEDEP}]
		>=dev-python/flaky-3.7[${PYTHON_USEDEP}]
		>=dev-python/psutil-5.9.5[${PYTHON_USEDEP}]
		>=dev-python/pytest-mock-3.11.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-3.3.1[${PYTHON_USEDEP}]
		>=dev-python/re-assert-1.1[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			>=dev-python/time-machine-2.10[${PYTHON_USEDEP}]
		' 'python*')
	)
"

distutils_enable_tests pytest

python_test() {
	# devpi_process is not packaged, and has lots of dependencies
	cat > "${T}"/devpi_process.py <<-EOF || die
		def IndexServer(*args, **kwargs): raise NotImplementedError()
	EOF

	local -x PYTHONPATH=${T}:${PYTHONPATH}
	local EPYTEST_DESELECT=(
		# Internet
		tests/tox_env/python/virtual_env/package/test_package_cmd_builder.py::test_build_wheel_external
	)
	local EPYTEST_IGNORE=(
		# requires devpi*
		tests/test_provision.py
	)

	[[ ${EPYTHON} == pypy3 ]] && EPYTEST_DESELECT+=(
		'tests/tox_env/python/pip/test_pip_install.py::test_constrain_package_deps[explicit-True-True]'
		'tests/tox_env/python/pip/test_pip_install.py::test_constrain_package_deps[requirements-True-True]'
		'tests/tox_env/python/pip/test_pip_install.py::test_constrain_package_deps[constraints-True-True]'
		'tests/tox_env/python/pip/test_pip_install.py::test_constrain_package_deps[explicit+requirements-True-True]'
		'tests/tox_env/python/pip/test_pip_install.py::test_constrain_package_deps[requirements_indirect-True-True]'
		'tests/tox_env/python/pip/test_pip_install.py::test_constrain_package_deps[requirements_constraints_indirect-True-True]'
	)

	epytest
}
