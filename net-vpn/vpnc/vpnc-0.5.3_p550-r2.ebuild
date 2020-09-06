# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info systemd tmpfiles toolchain-funcs vcs-snapshot

DESCRIPTION="Free client for Cisco VPN routing software"
HOMEPAGE="https://www.unix-ag.uni-kl.de/~massar/vpnc/"
SRC_URI="https://github.com/streambinder/vpnc/archive/fa0689c.tar.gz -> ${PF}.tar.gz"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 sparc x86"
IUSE="resolvconf +gnutls selinux"
RESTRICT="!gnutls? ( bindist )"

DEPEND="
	dev-lang/perl
	dev-libs/libgcrypt:0=
	>=sys-apps/iproute2-2.6.19.20061214[-minimal]
	gnutls? ( net-libs/gnutls:0= )
	!gnutls? ( dev-libs/openssl:0= )"
RDEPEND="${DEPEND}
	resolvconf? ( virtual/resolvconf )
	selinux? ( sec-policy/selinux-vpn )"

CONFIG_CHECK="~TUN"

S="${WORKDIR}/${PF}"
PATCHES=( "${FILESDIR}"/${PF}-var-run-fhs-3.0.patch )

src_configure() {
	tc-export CC
	export OPENSSL_GPL_VIOLATION=$(usex !gnutls)
}

src_install() {
	emake PREFIX="/usr" DESTDIR="${ED}" install
	dodoc README.md TODO VERSION

	keepdir /etc/vpnc/scripts.d
	newinitd "${FILESDIR}"/vpnc-3.init vpnc
	newconfd "${FILESDIR}"/vpnc.confd vpnc
	sed -e "s:/usr/local:${EPREFIX}/usr:" -i "${ED}"/etc/vpnc/vpnc-script || die

	dotmpfiles "${FILESDIR}"/vpnc-tmpfiles.conf
	systemd_newunit "${FILESDIR}"/vpnc.service vpnc@.service

	# COPYING file resides here, should not be installed
	rm -r "${ED}"/usr/share/doc/vpnc/ || die
}

pkg_postinst() {
	tmpfiles_process vpnc-tmpfiles.conf

	elog "You can generate a configuration file from the original Cisco profiles of your"
	elog "connection by using /usr/bin/pcf2vpnc to convert the .pcf file"
	elog "A guide is available at https://wiki.gentoo.org/wiki/Vpnc"

	if use gnutls; then
		elog "Will build with GnuTLS (default) instead of OpenSSL so you may even redistribute binaries."
		elog "See the Makefile itself and https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=440318"
	else
		ewarn "Building SSL support with OpenSSL instead of GnuTLS. This means that"
		ewarn "you are not allowed to re-distibute the binaries due to conflicts between BSD license and GPL,"
		ewarn "see the vpnc Makefile and https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=440318"
	fi
}
