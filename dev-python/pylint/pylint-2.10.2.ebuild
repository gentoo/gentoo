# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Python code static checker"
HOMEPAGE="https://www.logilab.org/project/pylint
	https://pypi.org/project/pylint/
	https://github.com/pycqa/pylint/"
SRC_URI="
	https://github.com/pycqa/pylint/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="examples"

RDEPEND="
	<dev-python/astroid-2.8[${PYTHON_USEDEP}]
	>=dev-python/astroid-2.7.2[${PYTHON_USEDEP}]
	>=dev-python/isort-4.2.5[${PYTHON_USEDEP}]
	<dev-python/isort-6[${PYTHON_USEDEP}]
	>=dev-python/mccabe-0.6[${PYTHON_USEDEP}]
	<dev-python/mccabe-0.7[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/toml-0.7.1[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${PN}-2.4.4-sphinx-theme.patch"
)

distutils_enable_sphinx doc --no-autodoc
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# No need to run the benchmarks
		tests/benchmark/test_baseline_benchmarks.py
	)
	# Specify the test directory explicitly to avoid import file mismatches
	epytest tests
}

python_install_all() {
	if use examples ; then
		docompress -x "/usr/share/doc/${PF}/examples"
		docinto examples
		dodoc -r examples/.
	fi

	distutils-r1_python_install_all
}
