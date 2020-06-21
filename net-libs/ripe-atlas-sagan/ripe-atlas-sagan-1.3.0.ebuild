# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="A parsing library for RIPE Atlas result strings"
HOMEPAGE="https://atlas.ripe.net/"
MY_GITHUB_AUTHOR="RIPE-NCC"
SRC_URI="https://github.com/${MY_GITHUB_AUTHOR}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
DOCS=( CHANGES.rst README.rst )

RDEPEND="
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	dev-python/ujson[${PYTHON_USEDEP}]
"

distutils_enable_tests nose
distutils_enable_sphinx docs
