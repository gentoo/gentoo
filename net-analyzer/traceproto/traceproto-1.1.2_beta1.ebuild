# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_PV=${PV/_/}

DESCRIPTION="A traceroute-like utility that sends packets based on protocol"
HOMEPAGE="http://traceproto.sourceforge.net/"
SRC_URI="mirror://gentoo/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE="debug"

RDEPEND="
	net-libs/libnet:1.1
	net-libs/libpcap
	sys-libs/ncurses:0=
	debug? ( dev-libs/dmalloc )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/doxygen[dot]
	virtual/pkgconfig
"

S=${WORKDIR}/${PN}-${MY_PV}

DOCS=( AUTHORS ChangeLog NEWS README TODO )

PATCHES=(
	"${FILESDIR}/${P}-tinfo.patch"
	"${FILESDIR}/${P}-fno-common.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable debug dmalloc)
}
