# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils

DESCRIPTION="A set of tools to collect and process netflow data"
HOMEPAGE="https://github.com/phaag/nfdump"
SRC_URI="
	${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${HOMEPAGE}/commit/ff0e855bd1f51bed9fc5d8559c64d3cfb475a5d8.patch
"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="compat15 debug ftconv nfprofile nftrack readpcap sflow"

COMMON_DEPEND="
	app-arch/bzip2
	sys-libs/zlib
	ftconv? ( sys-libs/zlib net-analyzer/flow-tools )
	nfprofile? ( net-analyzer/rrdtool )
	nftrack? ( net-analyzer/rrdtool )
	readpcap? ( net-libs/libpcap )
"
DEPEND="
	${COMMON_DEPEND}
	sys-devel/flex
	virtual/yacc
"
RDEPEND="
	${COMMON_DEPEND}
	dev-lang/perl
"

DOCS=( AUTHORS ChangeLog NEWS README )

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-1.6.14-libft.patch \
		"${FILESDIR}"/${PN}-1.6.14-libnfdump.patch \
		"${DISTDIR}"/ff0e855bd1f51bed9fc5d8559c64d3cfb475a5d8.patch

	eautoreconf
}

src_configure() {
	# --without-ftconf is not handled well #322201
	econf \
		$(use ftconv && echo "--enable-ftconv --with-ftpath=/usr") \
		$(use nfprofile && echo --enable-nfprofile) \
		$(use nftrack && echo --enable-nftrack) \
		$(use_enable compat15) \
		$(use_enable debug devel) \
		$(use_enable readpcap) \
		$(use_enable sflow)
}
