# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="SOCKS proxy connector for aiohttp"
HOMEPAGE="https://pypi.org/project/aiohttp-socks/"
SRC_URI="https://github.com/romis2012/aiohttp-socks/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-python/aiohttp-2.3.2[${PYTHON_USEDEP}]
"

DOCS=( README.md )
