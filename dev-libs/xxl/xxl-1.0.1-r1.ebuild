# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/xxl/xxl-1.0.1-r1.ebuild,v 1.1 2012/11/08 10:03:23 pinkbyte Exp $

EAPI=4

inherit eutils

DESCRIPTION="C/C++ library that provides exception handling and asset management"
HOMEPAGE="http://www.zork.org/xxl/"
SRC_URI="http://www.zork.org/software/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="threads static-libs"

DOCS=( README )

src_prepare() {
	epatch "${FILESDIR}"/${P}-nested-exception.patch
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable threads)
}

src_install() {
	default
	prune_libtool_files
}
