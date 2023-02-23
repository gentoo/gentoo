# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
# Re-add pypy3 after https://bugs.gentoo.org/729958
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Manage .env files"
HOMEPAGE="https://github.com/theskumar/python-dotenv"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

# Requirement <dev-python/sh-2 has an upstream ticket:
# https://github.com/theskumar/python-dotenv/issues/450
DEPEND="
	test? (
		>=dev-python/click-5[${PYTHON_USEDEP}]
		dev-python/ipython[${PYTHON_USEDEP}]
		<dev-python/sh-2[${PYTHON_USEDEP}]
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
