# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/sparsehash/sparsehash-1.5.2.ebuild,v 1.4 2011/04/28 13:33:14 jlec Exp $

DESCRIPTION="An extremely memory-efficient hash_map implementation"
HOMEPAGE="http://code.google.com/p/google-sparsehash/"
SRC_URI="http://google-sparsehash.googlecode.com/files/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	# Installs just every piece
	rm -rf "${D}/usr/share/doc"

	dodoc AUTHORS ChangeLog NEWS README TODO
	dohtml doc/*
}
