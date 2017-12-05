# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils

DESCRIPTION="A library and tools for trace processing"
HOMEPAGE="http://research.wand.net.nz/software/libtrace.php"
SRC_URI="http://research.wand.net.nz/software/${PN}/${P/_/-}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc ncurses numa static-libs"

RDEPEND="
	>=net-libs/libpcap-0.8
	dev-libs/openssl:0=
	ncurses? ( sys-libs/ncurses:0= )
	net-libs/wandio
	numa? ( sys-process/numactl )
"
DEPEND="
	${RDEPEND}
	app-doc/doxygen
	sys-devel/flex
	virtual/pkgconfig
	virtual/yacc
"
PATCHES=(
		"${FILESDIR}"/${PN}-3.0.20-autoconf-1.13.patch
		"${FILESDIR}"/${PN}-3.0.20-tinfo.patch
		"${FILESDIR}"/${PN}-4.0.0-no-examples.patch
		"${FILESDIR}"/${PN}-4.0.0-with-numa.patch
)
S=${WORKDIR}/${P/_beta/}

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_with ncurses) \
		$(use_with numa) \
		--with-man
}

src_install() {
	default

	use doc && dodoc -r docs/doxygen/html

	prune_libtool_files --modules
}
