# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DESCRIPTION="NetBSD FTP client with several advanced features"
SRC_URI="ftp://ftp.netbsd.org/pub/NetBSD/misc/${PN}/${P}.tar.gz"
HOMEPAGE="ftp://ftp.netbsd.org/pub/NetBSD/misc/tnftp/"

SLOT="0"
LICENSE="BSD-4 BSD ISC"
KEYWORDS="amd64 ~arm64 ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="ipv6 socks5 ssl"
REQUIRED_USE="socks5? ( !ipv6 )"

DEPEND=">=sys-libs/ncurses-5.1
	dev-libs/libedit
	socks5? ( net-proxy/dante )
	ssl? ( dev-libs/openssl:= )"
RDEPEND="${DEPEND}"

DOCS=( ChangeLog README THANKS )

src_configure() {
	econf \
		--enable-editcomplete \
		--without-local-libedit \
		$(use_enable ipv6) \
		$(use_enable ssl) \
		$(use_with socks5 socks)
}
