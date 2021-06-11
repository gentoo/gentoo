# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python3_{7..8})

inherit distutils-r1

DESCRIPTION="manages your Python library's sample data files"
HOMEPAGE="https://github.com/fatiando/pooch"
SRC_URI="https://github.com/fatiando/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}"

distutils_enable_sphinx doc dev-python/sphinx_rtd_theme
