# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Plugin for pytest that changes the default look and feel of pytest"
HOMEPAGE="
	https://pivotfinland.com/pytest-sugar
	https://github.com/Teemu/pytest-sugar
	https://pypi.org/project/pytest-sugar
"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/packaging-14.1[${PYTHON_USEDEP}]
	>=dev-python/pytest-xdist-1.14[${PYTHON_USEDEP}]
	>=dev-python/termcolor-1.1.0[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest
