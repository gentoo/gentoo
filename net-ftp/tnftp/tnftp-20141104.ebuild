# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

DESCRIPTION="NetBSD FTP client with several advanced features"
SRC_URI="ftp://ftp.netbsd.org/pub/NetBSD/misc/${PN}/${P}.tar.gz
	ftp://ftp.netbsd.org/pub/NetBSD/misc/${PN}/old/${P}.tar.gz"
HOMEPAGE="ftp://ftp.netbsd.org/pub/NetBSD/misc/tnftp/"

SLOT="0"
LICENSE="BSD-4 BSD ISC"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="ipv6 socks5"

DEPEND=">=sys-libs/ncurses-5.1
	socks5? ( net-proxy/dante )"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		--enable-editcomplete \
		$(use_enable ipv6) \
		$(use_with socks5 socks)
}

src_install() {
	emake install DESTDIR="${D}"
	dodoc ChangeLog README THANKS
}
