# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Library for transparent file I/O with compression"
HOMEPAGE="http://research.wand.net.nz/software/libwandio.php"
SRC_URI="http://research.wand.net.nz/software/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/2"
KEYWORDS="~amd64 ~x86"
IUSE="bzip2 http lzma lzo static-libs zlib"

RDEPEND="
	!<net-libs/libtrace-4
	bzip2? ( app-arch/bzip2 )
	lzma? ( app-arch/xz-utils )
	lzo? ( dev-libs/lzo )
	http? ( net-misc/curl )
	zlib? ( sys-libs/zlib )
"
DEPEND="
	${RDEPEND}
"

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_with bzip2) \
		$(use_with http) \
		$(use_with lzma) \
		$(use_with lzo) \
		$(use_with zlib)
}
