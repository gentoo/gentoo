# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

MY_PN="${PN#sphinx-}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Sphinx theme for aiohttp"
HOMEPAGE="https://github.com/aio-libs/aiohttp-theme"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ia64 ~sparc x86"
IUSE=""

RDEPEND="dev-python/sphinx[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"
