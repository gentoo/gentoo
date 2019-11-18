# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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
