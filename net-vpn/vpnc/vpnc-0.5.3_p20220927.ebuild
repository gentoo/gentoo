# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info systemd tmpfiles toolchain-funcs

DESCRIPTION="Free client for Cisco VPN routing software"
HOMEPAGE="https://www.unix-ag.uni-kl.de/~massar/vpnc/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/streambinder/vpnc.git"
else
	inherit vcs-snapshot
	SRC_URI="
		https://api.github.com/repos/streambinder/vpnc/tarball/fdd0de7 -> ${P}.tar.gz
		https://dev.gentoo.org/~soap/distfiles/${PN}-0.5.3-docs.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="resolvconf +gnutls selinux"
RESTRICT="!gnutls? ( bindist )"

DEPEND="
	dev-libs/libgcrypt:=
	sys-apps/iproute2[-minimal]
	gnutls? ( net-libs/gnutls:= )
	!gnutls? ( dev-libs/openssl:= )"
RDEPEND="${DEPEND}
	>=net-vpn/vpnc-scripts-20210402-r1
	resolvconf? ( virtual/resolvconf )
	selinux? ( sec-policy/selinux-vpn )"
BDEPEND="
	dev-lang/perl
	virtual/pkgconfig"

CONFIG_CHECK="~TUN"

src_unpack() {
	if [[ ${PV} == *9999 ]]; then
		git-r3_src_unpack
	else
		vcs-snapshot_src_unpack
		mv vpnc-0.5.3-docs/src/doc/*.md "${S}"/src/doc/ || die
	fi
}

src_configure() {
	tc-export CC PKG_CONFIG
	export OPENSSL_GPL_VIOLATION=$(usex !gnutls)
}

src_install() {
	emake PREFIX="${EPREFIX}"/usr DOCDIR='$(PREFIX)'/share/doc/${PF} DESTDIR="${D}" install

	keepdir /etc/vpnc/scripts.d
	newinitd "${FILESDIR}"/vpnc-3.init vpnc
	newconfd "${FILESDIR}"/vpnc.confd vpnc

	dotmpfiles "${FILESDIR}"/vpnc-tmpfiles.conf
	systemd_newunit "${FILESDIR}"/vpnc.service vpnc@.service

	# LICENSE file resides here, should not be installed
	rm -r "${ED}"/usr/share/licenses || die
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
