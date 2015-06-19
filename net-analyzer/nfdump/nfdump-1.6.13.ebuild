# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nfdump/nfdump-1.6.13.ebuild,v 1.2 2014/12/04 10:15:19 jer Exp $

EAPI=5
inherit autotools eutils

MY_P="${P/_/}"
DESCRIPTION="A set of tools to collect and process netflow data"
HOMEPAGE="http://nfdump.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/nfdump/${MY_P}.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="compat15 debug ftconv nfprofile nftrack readpcap sflow"

COMMON_DEPEND="
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

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-libft.patch

	sed -i bin/Makefile.am -e '/^AM_CFLAGS/d' || die

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
