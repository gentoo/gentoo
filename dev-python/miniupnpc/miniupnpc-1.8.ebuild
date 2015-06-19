# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/miniupnpc/miniupnpc-1.8.ebuild,v 1.5 2015/04/08 08:05:17 mgorny Exp $

EAPI=5

PYTHON_COMPAT=(python2_7 pypy)

inherit distutils-r1

DESCRIPTION="Python bindings for UPnP client library"
HOMEPAGE="http://miniupnp.free.fr/"
SRC_URI="http://miniupnp.free.fr/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND=">=net-libs/miniupnpc-${PV}"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/0001-Link-Python-module-against-the-shared-library.patch
)

# DOCS are installed by net-libs/miniupnpc.
DOCS=()
