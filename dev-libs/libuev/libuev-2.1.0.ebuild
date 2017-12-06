# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=6

inherit eutils ltprune

DESCRIPTION="Libite is a collection of useful BSD APIs"
HOMEPAGE="https://github.com/troglobit/libuev"
SRC_URI="https://github.com/troglobit/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND=""
RDEPEND="${DEPEND}"

src_configure(){
	econf --enable-static=$(usex static-libs)
}

src_install(){
	default
	prune_libtool_files
}
