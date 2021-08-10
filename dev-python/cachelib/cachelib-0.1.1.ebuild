# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Collection of cache libraries in the same API interface. Extracted from werkzeug"
HOMEPAGE="https://pypi.org/project/cachelib/ https://github.com/pallets/cachelib"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE=""

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
