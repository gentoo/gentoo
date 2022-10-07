# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="CFFI bindings to the Argon2 password hashing library"
HOMEPAGE="
	https://github.com/hynek/argon2-cffi/
	https://pypi.org/project/argon2-cffi/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/argon2-cffi-bindings-21.2.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"

DOCS=( AUTHORS.rst FAQ.rst README.rst )

distutils_enable_sphinx docs \
	dev-python/furo \
	dev-python/sphinx-notfound-page
distutils_enable_tests pytest
