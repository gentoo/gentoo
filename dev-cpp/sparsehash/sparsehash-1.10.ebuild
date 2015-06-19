# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/sparsehash/sparsehash-1.10.ebuild,v 1.4 2012/06/17 02:15:27 jdhore Exp $

EAPI="4"

inherit eutils

DESCRIPTION="An extremely memory-efficient hash_map implementation"
HOMEPAGE="http://code.google.com/p/google-sparsehash/"
SRC_URI="http://google-sparsehash.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${PV}-gcc46.patch
}

src_install() {
	default

	# Installs just every piece
	rm -rf "${D}/usr/share/doc"
	dohtml doc/*
}
