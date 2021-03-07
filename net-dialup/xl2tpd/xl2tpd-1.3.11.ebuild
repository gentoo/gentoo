# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit systemd toolchain-funcs tmpfiles

DESCRIPTION="A modern version of the Layer 2 Tunneling Protocol (L2TP) daemon"
HOMEPAGE="http://www.xelerance.com/services/software/xl2tpd/"
SRC_URI="https://github.com/xelerance/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86"
IUSE="dnsretry"

DEPEND="
	net-libs/libpcap
	>sys-kernel/linux-headers-2.6"

RDEPEND="
	${DEPEND}
	net-dialup/ppp"

DOCS=(CREDITS README.xl2tpd BUGS CHANGES TODO doc/README.patents)

src_prepare() {
	default
	# The below patch is questionable. Why wasn't it submitted upstream? If it
	# ever breaks, it will just be removed. -darkside 20120914
	# Patch has been discussed with upstream and is marked as feature by now:
	# https://github.com/xelerance/xl2tpd/issues/134 // -- tenX 2017-08-06
	use dnsretry && eapply -p0 "${FILESDIR}/${PN}-dnsretry.patch"
}

src_compile() {
	tc-export CC
	emake OSFLAGS="-DLINUX"
}

src_install() {
	emake PREFIX=/usr DESTDIR="${D}" install

	insinto /etc/xl2tpd
	newins doc/l2tpd.conf.sample xl2tpd.conf
	newins doc/l2tp-secrets.sample l2tp-secrets
	fperms 0600 /etc/xl2tpd/l2tp-secrets

	newinitd "${FILESDIR}"/xl2tpd-init-r1 xl2tpd

	systemd_dounit "${FILESDIR}"/xl2tpd.service
	dotmpfiles "${FILESDIR}"/xl2tpd.conf

	einstalldocs
}
