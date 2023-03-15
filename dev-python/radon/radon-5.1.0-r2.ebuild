# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Code Metrics in Python"
HOMEPAGE="
	https://radon.readthedocs.io/
	https://github.com/rubik/radon/
	https://pypi.org/project/radon/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"

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
