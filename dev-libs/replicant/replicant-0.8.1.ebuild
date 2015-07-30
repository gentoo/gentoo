# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/replicant/replicant-0.8.1.ebuild,v 1.1 2015/07/30 06:04:31 patrick Exp $
EAPI=4

DESCRIPTION="Hyperdex replicant support library"

HOMEPAGE="http://hyperdex.org"
SRC_URI="http://hyperdex.org/src/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

DEPEND=">=dev-libs/libpo6-0.8
	>=dev-libs/libe-0.11
	>=dev-libs/busybee-0.7
	dev-libs/hyperleveldb
	dev-cpp/glog
	dev-cpp/sparsehash"
RDEPEND="${DEPEND}"
