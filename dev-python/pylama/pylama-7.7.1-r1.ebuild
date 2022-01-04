# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Code audit tool for python"
HOMEPAGE="https://github.com/klen/pylama"
SRC_URI="https://github.com/klen/pylama/archive/${PV}.tar.gz -> ${P}.tar.gz"
# pypi tarball excludes unit tests
#SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

RDEPEND="
	>=dev-python/mccabe-0.5.2[${PYTHON_USEDEP}]
	dev-python/pycodestyle[${PYTHON_USEDEP}]
	dev-python/pydocstyle[${PYTHON_USEDEP}]
	dev-python/pyflakes[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/mypy[${PYTHON_USEDEP}]
		dev-vcs/git
	)
"

distutils_enable_sphinx docs
distutils_enable_tests pytest

python_prepare_all() {
	sed -e "s|exclude=\['plugins'\]|exclude=['plugins', 'tests']|" -i setup.py || die
	sed -e 's|^\(def\) \(test_ignore_select\)|\1 _\2|' -i tests/test_config.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	local EPYTEST_DESELECT=(
		# Disable eradicate until it is fixed:
		# https://github.com/klen/pylama/issues/190
		tests/test_linters.py::test_eradicate
	)
	epytest tests
}
