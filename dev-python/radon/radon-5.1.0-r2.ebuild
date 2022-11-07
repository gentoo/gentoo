# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Code Metrics in Python"
HOMEPAGE="
	https://radon.readthedocs.io/
	https://github.com/rubik/radon/
	https://pypi.org/project/radon/
"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/flake8[${PYTHON_USEDEP}]
	dev-python/mando[${PYTHON_USEDEP}]
	dev-python/pytest-mock[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs
distutils_enable_tests pytest

src_prepare() {
	# unpin the dep
	sed -i -e '/mando/s:,<0.7::' setup.py || die
	distutils-r1_src_prepare
}
