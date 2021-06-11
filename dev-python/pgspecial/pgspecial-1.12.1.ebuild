# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Python implementation of PostgreSQL meta commands"
HOMEPAGE="https://github.com/dbcli/pgspecial"
SRC_URI="https://github.com/dbcli/pgspecial/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	>=dev-python/click-4.1[${PYTHON_USEDEP}]
	>=dev-python/configobj-5.0.6[${PYTHON_USEDEP}]
	>=dev-python/psycopg-2.7.4[${PYTHON_USEDEP}]
	>=dev-python/sqlparse-0.1.19[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
DOCS=( License.txt README.rst changelog.rst  )
