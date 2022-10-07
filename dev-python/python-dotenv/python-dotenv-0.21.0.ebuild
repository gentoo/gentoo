# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Manage .env files"
HOMEPAGE="https://github.com/theskumar/python-dotenv"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

DEPEND="
	test? (
		>=dev-python/click-5[${PYTHON_USEDEP}]
		>=dev-python/sh-1.09[${PYTHON_USEDEP}]
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
