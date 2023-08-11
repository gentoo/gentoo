# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 multiprocessing

DESCRIPTION="Optional static typing for Python"
HOMEPAGE="
	https://www.mypy-lang.org/
	https://github.com/python/mypy/
	https://pypi.org/project/mypy/
"
SRC_URI="
	https://github.com/python/mypy/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

# stubgen collides with this package: https://bugs.gentoo.org/585594
RDEPEND="
	!dev-util/stubgen
	>=dev-python/psutil-4[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.1.0[${PYTHON_USEDEP}]
	>=dev-python/mypy_extensions-1.0.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/tomli[${PYTHON_USEDEP}]
	' 3.{9..10})
"
BDEPEND="
	test? (
		>=dev-python/attrs-18.0[${PYTHON_USEDEP}]
		>=dev-python/filelock-3.3.0[${PYTHON_USEDEP}]
		>=dev-python/lxml-4.4.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.4.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-1.18[${PYTHON_USEDEP}]
		>=dev-python/py-1.5.2[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
		>=dev-python/virtualenv-16.0.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

# this requires packaging a lot of type stubs
export MYPY_USE_MYPYC=0

python_test() {
	local EPYTEST_DESELECT=(
		# the majority of them require Internet (via pip)
		mypy/test/testpep561.py
	)
	# Some mypy/test/testcmdline.py::PythonCmdlineSuite tests
	# fail with high COLUMNS values
	local -x COLUMNS=80
	epytest -n "$(makeopts_jobs)" --dist=worksteal
}
