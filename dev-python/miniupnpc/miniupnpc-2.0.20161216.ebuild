# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} pypy{,3} )

inherit distutils-r1

DESCRIPTION="Python bindings for UPnP client library"
HOMEPAGE="http://miniupnp.free.fr/"
SRC_URI="http://miniupnp.free.fr/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND=">=net-libs/miniupnpc-${PV}:0="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/miniupnpc-1.9.20150917-shared-lib.patch
)

# DOCS are installed by net-libs/miniupnpc.
DOCS=()

# Example test command:
# python -c 'import miniupnpc; u = miniupnpc.UPnP(); u.discover(); u.selectigd(); print(u.externalipaddress())'
