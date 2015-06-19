# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/xl2tpd/xl2tpd-1.3.1-r2.ebuild,v 1.3 2013/02/13 15:19:30 ago Exp $

EAPI="4"

inherit eutils toolchain-funcs vcs-snapshot

DESCRIPTION="A modern version of the Layer 2 Tunneling Protocol (L2TP) daemon"
HOMEPAGE="http://www.xelerance.com/services/software/xl2tpd/"
SRC_URI="https://github.com/xelerance/${PN}/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="dnsretry +kernel"

DEPEND="net-libs/libpcap"
RDEPEND="${DEPEND}
	net-dialup/ppp"
DEPEND+=" kernel? ( >=sys-kernel/linux-headers-2.6.23 )"

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.3.0-LDFLAGS.patch"
	epatch "${FILESDIR}/${PN}-1.3.1-CFLAGS.patch"
	epatch "${FILESDIR}/${PN}-1.3.1-no-type-punning-b119c0da.patch"
	epatch "${FILESDIR}/${PN}-1.3.1-kernelmode.patch"
	sed -i Makefile -e 's| -O2||g' || die "sed Makefile"
	# The below patch is questionable. Why wasn't it submitted upstream? If it
	# ever breaks, it will just be removed. -darkside 20120914
	use dnsretry && epatch "${FILESDIR}/${PN}-dnsretry.patch"
	# Remove bundled headers
	rm -r linux || die
}

src_compile() {
	tc-export CC
	export OSFLAGS="-DLINUX"
	use kernel && OSFLAGS+=" -DUSE_KERNEL"
	emake
}

src_install() {
	emake PREFIX=/usr DESTDIR="${D}" install

	dodoc CREDITS README.xl2tpd BUGS CHANGES TODO doc/README.patents doc/rfc2661.txt

	dodir /etc/xl2tpd
	cp doc/l2tp-secrets.sample "${ED}/etc/xl2tpd/l2tp-secrets" || die
	cp doc/l2tpd.conf.sample "${ED}/etc/xl2tpd/xl2tpd.conf" || die
	fperms 0600 /etc/xl2tpd/l2tp-secrets
	newinitd "${FILESDIR}"/xl2tpd-init-r1 xl2tpd
}
