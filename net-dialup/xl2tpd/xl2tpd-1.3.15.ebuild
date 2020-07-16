# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd toolchain-funcs

DESCRIPTION="A modern version of the Layer 2 Tunneling Protocol (L2TP) daemon"
HOMEPAGE="https://github.com/xelerance/xl2tpd"
SRC_URI="https://github.com/xelerance/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86"
IUSE="+kernel"

DEPEND="
	net-libs/libpcap
	>=sys-kernel/linux-headers-2.6"

RDEPEND="
	${DEPEND}
	net-dialup/ppp"

DOCS=(CREDITS README.md BUGS CHANGES TODO doc/README.patents)

src_compile() {
	tc-export CC
	local OSFLAGS="-DLINUX"
	use kernel && OSFLAGS+=" -DUSE_KERNEL"
	emake OSFLAGS="$OSFLAGS"
}

src_install() {
	emake PREFIX=/usr DESTDIR="${D}" install

	newinitd "${FILESDIR}"/xl2tpd-init-r1 xl2tpd

	systemd_dounit "${FILESDIR}"/xl2tpd.service
	systemd_dotmpfilesd "${FILESDIR}"/xl2tpd.conf

	einstalldocs

	insinto /etc/xl2tpd
	newins doc/l2tpd.conf.sample xl2tpd.conf
	insopts -m 0600
	newins doc/l2tp-secrets.sample l2tp-secrets
}
