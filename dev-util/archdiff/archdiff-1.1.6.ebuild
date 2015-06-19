# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/archdiff/archdiff-1.1.6.ebuild,v 1.1 2012/03/01 07:02:04 radhermit Exp $

EAPI="4"

DESCRIPTION="Utility to view the differences between two source code archives"
HOMEPAGE="https://frigidcode.com/code/archdiff/"
SRC_URI="https://frigidcode.com/code/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+bzip2 +lzma +gzip"

DEPEND="app-arch/libarchive[bzip2?,lzma?]
	gzip? ( app-arch/libarchive[zlib] )
	dev-libs/rremove"
RDEPEND="${DEPEND}
	app-misc/colordiff"

src_configure() {
	econf \
		$(use_enable bzip2) \
		$(use_enable gzip) \
		$(use_enable lzma)
}
