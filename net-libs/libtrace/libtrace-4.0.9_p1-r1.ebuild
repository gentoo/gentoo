# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="A library and tools for trace processing"
HOMEPAGE="https://research.wand.net.nz/software/libtrace.php"
SRC_URI="https://github.com/${PN^}Team/${PN}/archive//${PV/_p/-}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc ncurses numa static-libs"

RDEPEND="
	>=net-libs/libpcap-0.8
	dev-libs/libyaml
	dev-libs/openssl:0=
	net-libs/wandio
	ncurses? ( sys-libs/ncurses:0= )
	numa? ( sys-process/numactl )
"
DEPEND="
	${RDEPEND}
	app-doc/doxygen[dot]
	sys-devel/flex
	virtual/os-headers
	virtual/pkgconfig
	virtual/yacc
"
PATCHES=(
		"${FILESDIR}"/${PN}-3.0.20-autoconf-1.13.patch
		"${FILESDIR}"/${PN}-4.0.0-no-examples.patch
		"${FILESDIR}"/${PN}-4.0.0-with-numa.patch
		"${FILESDIR}"/${PN}-4.0.9_p1-tinfo.patch
		"${FILESDIR}"/${PN}-4.0.9_p1-SIOCGSTAMP.patch
)
S=${WORKDIR}/${P/_p/-}

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

	find "${D}" -name "*.la" -delete || die
}
