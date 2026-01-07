# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Please keep a version around that matches Debian/Ubuntu for compatibility.
inherit systemd

DESCRIPTION="tinc is an easy to configure VPN implementation"
HOMEPAGE="https://www.tinc-vpn.org/"
SRC_URI="https://www.tinc-vpn.org/packages/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="+lzo uml vde +zlib"

DEPEND="
	dev-libs/openssl:=
	lzo? ( dev-libs/lzo:2 )
	zlib? ( virtual/zlib:= )
"
RDEPEND="
	${DEPEND}
	vde? ( net-misc/vde )
"

src_configure() {
	econf \
		--enable-jumbograms \
		--disable-tunemu  \
		$(use_enable lzo) \
		$(use_enable uml) \
		$(use_enable vde) \
		$(use_enable zlib)
}

src_install() {
	emake DESTDIR="${D}" install
	dodir /etc/tinc
	dodoc AUTHORS NEWS README THANKS
	doconfd "${FILESDIR}"/tinc.networks
	newconfd "${FILESDIR}"/tincd.conf tincd
	newinitd "${FILESDIR}"/tincd-r1 tincd
	systemd_newunit "${FILESDIR}"/tincd_at.service "tincd@.service"
}
