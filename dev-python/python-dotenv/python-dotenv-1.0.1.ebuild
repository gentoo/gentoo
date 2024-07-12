# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Manage .env files"
HOMEPAGE="
	https://github.com/theskumar/python-dotenv/
	https://pypi.org/project/python-dotenv/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

BDEPEND="
	test? (
		>=dev-python/click-5[${PYTHON_USEDEP}]
		dev-python/ipython[${PYTHON_USEDEP}]
		>=dev-python/sh-2[${PYTHON_USEDEP}]
	)
"

DOCS=( CHANGELOG.md README.md )

distutils_enable_tests pytest

python_install() {
	distutils-r1_python_install
	ln -s dotenv "${D}$(python_get_scriptdir)"/python-dotenv || die
}

src_install() {
	distutils-r1_src_install

	# Avoid collision with dev-ruby/dotenv (bug #798648)
	mv "${ED}"/usr/bin/{,python-}dotenv || die
}
