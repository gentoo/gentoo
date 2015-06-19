# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/sparsehash/sparsehash-2.0.2.ebuild,v 1.4 2012/11/27 17:37:33 bicatali Exp $

EAPI="4"

DESCRIPTION="An extremely memory-efficient hash_map implementation"
HOMEPAGE="http://code.google.com/p/sparsehash/"
SRC_URI="http://sparsehash.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

src_install() {
	default

	# Installs just every piece
	rm -rf "${ED}/usr/share/doc"
	dohtml doc/*
}
