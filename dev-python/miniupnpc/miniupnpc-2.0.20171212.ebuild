# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy{,3} )

inherit distutils-r1

DESCRIPTION="Python bindings for UPnP client library"
HOMEPAGE="http://miniupnp.free.fr/"
SRC_URI="http://miniupnp.free.fr/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE=""

RDEPEND=">=net-libs/miniupnpc-${PV}:0="
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/miniupnpc-2.0.20171102-shared-lib.patch
)

# DOCS are installed by net-libs/miniupnpc.
DOCS=()

# Example test command:
# python -c 'import miniupnpc; u = miniupnpc.UPnP(); u.discover(); u.selectigd(); print(u.externalipaddress())'
