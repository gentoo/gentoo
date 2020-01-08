# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools git-r3

DESCRIPTION="A library and tools for trace processing"
HOMEPAGE="https://research.wand.net.nz/software/libtrace.php"
EGIT_REPO_URI="https://github.com/LibtraceTeam/libtrace"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS=""
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

	find "${D}" -name "*.la" -delete || die
}
