# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )

inherit distutils-r1

DESCRIPTION="a re-implementation of the asyncio mainloop on top of Trio"
HOMEPAGE="
	https://github.com/python-trio/trio-asyncio
	https://pypi.org/project/trio-asyncio/
"
SRC_URI="https://github.com/python-trio/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/outcome[${PYTHON_USEDEP}]
	dev-python/sniffio[${PYTHON_USEDEP}]
	>=dev-python/trio-0.15.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/pytest-trio-0.6[${PYTHON_USEDEP}]
	)
"
PATCHES=( "${FILESDIR}/no-pytest-runner.patch" )

distutils_enable_tests pytest
distutils_enable_sphinx docs/source dev-python/sphinxcontrib-trio
