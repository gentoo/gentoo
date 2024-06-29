# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN=${PN/-/.}
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Classes for orchestrating Python (virtual) environments"
HOMEPAGE="
	https://github.com/jaraco/jaraco.envs/
	https://pypi.org/project/jaraco.envs/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

RDEPEND="
	dev-python/path[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	# optional runtime dep, not used by anything in ::gentoo
	sed -i -e '/tox/d' setup.cfg || die
	distutils-r1_src_prepare
}

python_test() {
	epytest tests
}
