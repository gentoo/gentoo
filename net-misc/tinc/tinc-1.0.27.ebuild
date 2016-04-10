# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
inherit systemd

DESCRIPTION="tinc is an easy to configure VPN implementation"
HOMEPAGE="http://www.tinc-vpn.org/"
SRC_URI="http://www.tinc-vpn.org/packages/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="+lzo uml vde +zlib"

DEPEND="dev-libs/openssl:=
	lzo? ( dev-libs/lzo:2 )
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}
	vde? ( net-misc/vde )"

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

pkg_postinst() {
	elog "This package requires the tun/tap kernel device."
	elog "Look at http://www.tinc-vpn.org/ for how to configure tinc"
}
