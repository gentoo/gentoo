# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=4

DESCRIPTION="A messaging abstraction on top of TCP sockets used in HyperDex"

HOMEPAGE="http://hyperdex.org"
SRC_URI="http://hyperdex.org/src/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

DEPEND=">=dev-libs/libpo6-${PV}
	>=dev-libs/libe-${PV}"
RDEPEND="${DEPEND}"
