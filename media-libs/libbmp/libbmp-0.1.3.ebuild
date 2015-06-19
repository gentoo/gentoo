# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libbmp/libbmp-0.1.3.ebuild,v 1.1 2013/06/09 22:54:48 xmw Exp $

EAPI=5

inherit eutils

DESCRIPTION="C library for reading, writing, and modifying Windows bitmap image files"
HOMEPAGE="http://code.google.com/p/libbmp/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0/2"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND=""
RDEPEND=""

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files
}
