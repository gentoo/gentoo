# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/xl2tpd/xl2tpd-1.3.6.ebuild,v 1.4 2015/06/09 04:25:08 jer Exp $

EAPI="5"

inherit eutils systemd toolchain-funcs

DESCRIPTION="A modern version of the Layer 2 Tunneling Protocol (L2TP) daemon"
HOMEPAGE="http://www.xelerance.com/services/software/xl2tpd/"
SRC_URI="https://github.com/xelerance/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ppc64 ~x86"
IUSE="dnsretry"

DEPEND="net-libs/libpcap"
RDEPEND="${DEPEND}
	net-dialup/ppp"
DEPEND+=" >=sys-kernel/linux-headers-2.6.23"

src_prepare() {
	sed -i Makefile -e 's| -O2||g' || die "sed Makefile"
	# The below patch is questionable. Why wasn't it submitted upstream? If it
	# ever breaks, it will just be removed. -darkside 20120914
	use dnsretry && epatch "${FILESDIR}/${PN}-dnsretry.patch"
}

src_compile() {
	tc-export CC
	export OSFLAGS="-DLINUX"
	emake
}

src_install() {
	emake PREFIX=/usr DESTDIR="${D}" install
	dodoc CREDITS README.xl2tpd BUGS CHANGES TODO doc/README.patents doc/rfc2661.txt
	insinto /etc/xl2tpd
	newins doc/l2tpd.conf.sample xl2tpd.conf
	newins doc/l2tp-secrets.sample l2tp-secrets
	fperms 0600 /etc/xl2tpd/l2tp-secrets
	newinitd "${FILESDIR}"/xl2tpd-init-r1 xl2tpd
	systemd_dounit "${FILESDIR}"/xl2tpd.service
	systemd_dotmpfilesd "${FILESDIR}"/xl2tpd.conf
}
