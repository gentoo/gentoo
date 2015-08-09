# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils

DESCRIPTION="A library and tools for trace processing"
HOMEPAGE="http://research.wand.net.nz/software/libtrace.php"
SRC_URI="http://research.wand.net.nz/software/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bzip2 doc lzo ncurses static-libs zlib"

RDEPEND=">=net-libs/libpcap-0.8
	ncurses? ( sys-libs/ncurses )
	bzip2? ( app-arch/bzip2 )
	zlib? ( sys-libs/zlib )
	lzo? ( dev-libs/lzo )"
DEPEND="${RDEPEND}
	app-doc/doxygen
	sys-devel/flex
	virtual/yacc
	virtual/pkgconfig"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-3.0.20-autoconf-1.13.patch \
		"${FILESDIR}"/${PN}-3.0.20-no-examples.patch \
		"${FILESDIR}"/${PN}-3.0.20-tinfo.patch

	eautoreconf
}

src_configure() {
	econf \
		--with-man \
		$(use_enable static-libs static) \
		$(use_with ncurses) \
		$(use_with bzip2) \
		$(use_with zlib) \
		$(use_with lzo)
}

src_install() {
	default
	use doc && dohtml docs/doxygen/html/*
	prune_libtool_files --modules
}
