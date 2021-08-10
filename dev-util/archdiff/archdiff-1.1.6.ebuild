# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Utility to view the differences between two source code archives"
HOMEPAGE="https://frigidcode.com/code/archdiff/"
SRC_URI="https://frigidcode.com/code/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+bzip2 +lzma +zlib"

DEPEND="app-arch/libarchive[bzip2?,lzma?]
	zlib? ( app-arch/libarchive[zlib] )
	dev-libs/rremove"
RDEPEND="${DEPEND}
	app-misc/colordiff"

src_configure() {
	econf \
		$(use_enable bzip2) \
		$(use_enable zlib gzip) \
		$(use_enable lzma)
}
