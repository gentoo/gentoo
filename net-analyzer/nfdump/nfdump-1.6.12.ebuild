# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nfdump/nfdump-1.6.12.ebuild,v 1.4 2014/07/05 10:51:40 ago Exp $

EAPI=5
inherit autotools eutils

MY_P="${P/_/}"
DESCRIPTION="A set of tools to collect and process netflow data"
HOMEPAGE="http://nfdump.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/nfdump/${MY_P}.tar.gz
	http://www.oberhumer.com/opensource/lzo/download/minilzo-2.07.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="compat15 debug ftconv nfprofile nftrack readpcap sflow"

CDEPEND="
	ftconv? ( sys-libs/zlib net-analyzer/flow-tools )
	nfprofile? ( net-analyzer/rrdtool )
	nftrack? ( net-analyzer/rrdtool )
	readpcap? ( net-libs/libpcap )
"
DEPEND="
	${CDEPEND}
	sys-devel/flex
	virtual/yacc
"
RDEPEND="
	${CDEPEND}
	dev-lang/perl
"

DOCS=( AUTHORS ChangeLog NEWS README )

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-test-dep.patch

	# bug #515278
	cp "${WORKDIR}"/minilzo-2.07/*.{c,h} "${S}"/bin || die

	if use ftconv; then
		sed -e '/ftbuild.h/d' -i bin/ft2nfdump.c || die
		sed \
			-e 's:lib\(/ftlib.h\):include\1:' \
			-e 's:libft.a:libft.so:' \
			\-i configure.in || die
	fi
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
