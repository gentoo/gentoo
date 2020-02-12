# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python3_6 )
inherit distutils-r1

DESCRIPTION="Python wrapper for Google Geocoding API V3"
HOMEPAGE="http://code.xster.net/pygeocoder/overview"
SRC_URI="http://code.xster.net/${PN}/downloads/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-python/requests-1.0[${PYTHON_USEDEP}]"
