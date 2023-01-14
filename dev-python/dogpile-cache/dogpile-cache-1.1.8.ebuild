# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

MY_P=${P/-/.}
DESCRIPTION="A locking API for expiring values while a single thread generates a new value"
HOMEPAGE="
	https://github.com/sqlalchemy/dogpile.cache/
	https://pypi.org/project/dogpile.cache/
"
SRC_URI="mirror://pypi/${PN:0:1}/dogpile.cache/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"

RDEPEND="
	>=dev-python/decorator-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-3.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/mako[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
