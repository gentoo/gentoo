# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Dictdiffer is a library that helps you to diff and patch dictionaries"
HOMEPAGE="
	https://github.com/inveniosoftware/dictdiffer/
	https://pypi.org/project/dictdiffer/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86"
SLOT="0"

BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
# Requires self to be already installed
#distutils_enable_sphinx docs dev-python/sphinx-rtd-theme

python_prepare_all() {
	# remove dep on pytest-runner
	sed -i -e '/pytest-runner/d' setup.py || die

	# remove dep on pytest-pep8 and pytest-cov
	sed -i -e '/addopts/d' pytest.ini || die

	distutils-r1_python_prepare_all
}
