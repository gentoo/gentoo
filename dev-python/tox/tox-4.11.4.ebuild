# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="virtualenv-based automation of test activities"
HOMEPAGE="
	https://tox.readthedocs.io/
	https://github.com/tox-dev/tox/
	https://pypi.org/project/tox/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	dev-python/cachetools[${PYTHON_USEDEP}]
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/filelock[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/platformdirs[${PYTHON_USEDEP}]
	dev-python/pluggy[${PYTHON_USEDEP}]
	dev-python/pyproject-api[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/tomli[${PYTHON_USEDEP}]
	' 3.{9..10})
	dev-python/virtualenv[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		dev-python/build[${PYTHON_USEDEP}]
		dev-python/distlib[${PYTHON_USEDEP}]
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/re-assert[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/time-machine[${PYTHON_USEDEP}]
		' 'python*')
	)
"

distutils_enable_tests pytest

src_prepare() {
	# upstream lower bounds are meaningless
	sed -i -e 's:>=[0-9.]*::' pyproject.toml || die
	distutils-r1_src_prepare
}

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

	# tox leaves a *humonogous* tempdir which easily leads to ENOSPC
	# when running in parallel with other packages
	rm -r "${T}"/pytest* || die
}
