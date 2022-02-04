# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

MY_PV=$(ver_cut 1-3)-$(ver_cut 4)

DESCRIPTION="Ethernet/PPP IP Packet Monitor"
HOMEPAGE="http://www.slctech.org/~mackay/netwatch.html"
SRC_URI="http://www.slctech.org/~mackay/NETWATCH/${PN}-${MY_PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="doc"

RDEPEND="sys-libs/ncurses"
DEPEND="
	${RDEPEND}
	sys-kernel/linux-headers
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}"/${P}-append_ldflags.patch
	"${FILESDIR}"/${P}-open.patch
	"${FILESDIR}"/${P}-fix-fortify.patch
	"${FILESDIR}"/${P}-do-not-call.patch
	"${FILESDIR}"/${P}-includes.patch
	"${FILESDIR}"/${P}-tinfo.patch
	"${FILESDIR}"/${P}-fno-common.patch
)
S=${WORKDIR}/${PN}-$(ver_cut 1-3)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	dosbin netresolv netwatch

	doman netwatch.1
	dodoc BUGS CHANGES README* TODO

	if use doc; then
		docinto html
		dodoc NetwatchKeyCommands.html
	fi
}
