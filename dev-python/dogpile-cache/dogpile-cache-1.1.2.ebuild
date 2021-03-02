# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="A locking API for expiring values while a single thread generates a new value."
HOMEPAGE="https://github.com/sqlalchemy/dogpile.cache"
SRC_URI="mirror://pypi/${PN:0:1}/dogpile.cache/dogpile.cache-${PV}.tar.gz"
S="${WORKDIR}/dogpile.cache-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 x86"

RDEPEND="
	>=dev-python/decorator-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-3.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/mako[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
