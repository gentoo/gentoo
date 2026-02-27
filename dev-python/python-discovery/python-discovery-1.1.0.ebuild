# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_VERIFY_REPO=https://github.com/tox-dev/python-discovery
PYTHON_COMPAT=( pypy3_11 python3_{11..14} python3_{13,14}t )

inherit distutils-r1 pypi

DESCRIPTION="Python interpreter discovery"
HOMEPAGE="
	https://github.com/tox-dev/python-discovery/
	https://pypi.org/project/python-discovery/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND="
	>=dev-python/filelock-3.15.4[${PYTHON_USEDEP}]
	<dev-python/platformdirs-5[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-4.3.6[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		>=dev-python/setuptools-75.1[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-mock )
EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=()

	case ${EPYTHON} in
		python3.*t)
			EPYTEST_DESELECT+=(
				# TODO
				tests/test_py_info_extra.py::test_satisfies_path_not_abs_basename_match
			)
			;;
	esac

	epytest
}
