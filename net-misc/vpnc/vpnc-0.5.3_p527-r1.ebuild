# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/vpnc/vpnc-0.5.3_p527-r1.ebuild,v 1.15 2015/03/06 15:38:45 jlec Exp $

EAPI=5

inherit eutils linux-info systemd toolchain-funcs

DESCRIPTION="Free client for Cisco VPN routing software"
HOMEPAGE="http://www.unix-ag.uni-kl.de/~massar/vpnc/"
SRC_URI="http://dev.gentoo.org/~jlec/distfiles/${P}.tar.xz"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 sparc x86"
IUSE="resolvconf +gnutls selinux"

DEPEND="
	dev-lang/perl
	dev-libs/libgcrypt:0=
	>=sys-apps/iproute2-2.6.19.20061214[-minimal]
	gnutls? ( net-libs/gnutls )
	!gnutls? ( dev-libs/openssl:0= )"
RDEPEND="${DEPEND}
	resolvconf? ( net-dns/openresolv )
	selinux? ( sec-policy/selinux-vpn )
"

RESTRICT="!gnutls? ( bindist )"

CONFIG_CHECK="~TUN"

src_prepare() {
	if use gnutls; then
		elog "Will build with GnuTLS (default) instead of OpenSSL so you may even redistribute binaries."
		elog "See the Makefile itself and http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=440318"
	else
		sed -i -e '/^#OPENSSL_GPL_VIOLATION/s:#::g' "${S}"/Makefile	|| die
		ewarn "Building SSL support with OpenSSL instead of GnuTLS.  This means that"
		ewarn "you are not allowed to re-distibute the binaries due to conflicts between BSD license and GPL,"
		ewarn "see the vpnc Makefile and http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=440318"
	fi

	epatch "${FILESDIR}"/${PN}-0.5.3_p514-as-needed.patch

	sed -e 's:test/cert0.pem::g' -i Makefile || die

	tc-export CC

	sed \
		-e 's:/var/run:/run:g' \
		-i ChangeLog config.c TODO  || die
}

src_install() {
	emake PREFIX="/usr" DESTDIR="${D}" install
	dodoc README TODO VERSION
	keepdir /etc/vpnc/scripts.d
	newinitd "${FILESDIR}/vpnc-3.init" vpnc
	newconfd "${FILESDIR}/vpnc.confd" vpnc
	sed -e "s:/usr/local:/usr:" -i "${D}"/etc/vpnc/vpnc-script || die

	systemd_dotmpfilesd "${FILESDIR}"/vpnc-tmpfiles.conf
	systemd_newunit "${FILESDIR}"/vpnc.service vpnc@.service

	# COPYING file resides here, should not be installed
	rm -rf "${ED}"/usr/share/doc/vpnc/ || die
}

pkg_postinst() {
	elog "You can generate a configuration file from the original Cisco profiles of your"
	elog "connection by using /usr/bin/pcf2vpnc to convert the .pcf file"
	elog "A guide is available at https://wiki.gentoo.org/wiki/Vpnc"
}
