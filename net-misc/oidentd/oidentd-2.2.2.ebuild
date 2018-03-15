# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-info systemd user

DESCRIPTION="Another (RFC1413 compliant) ident daemon"
HOMEPAGE="https://oidentd.janikrabe.com/"
SRC_URI="https://ftp.janikrabe.com/pub/${PN}/releases/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="debug ipv6 masquerade selinux"

DEPEND="masquerade? (
		net-libs/libnetfilter_conntrack
		sys-libs/libcap-ng )"

RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-oident )"

pkg_setup() {
	local CONFIG_CHECK="~INET_TCP_DIAG"

	linux-info_pkg_setup

	enewgroup oidentd
	enewuser oidentd -1 -1 -1 oidentd
}

src_configure() {
	local myconf=(
		$(use_enable debug)
		$(use_enable ipv6)
		$(use_enable masquerade masq)
		$(use_enable masquerade nat)
	)
	econf "${myconf[@]}"
}

src_install() {
	default

	newinitd "${FILESDIR}"/${PN}-2.0.7-init ${PN}
	newconfd "${FILESDIR}"/${PN}-2.2.2-confd ${PN}

	systemd_newunit "${FILESDIR}"/${PN}_at.service-r1 ${PN}@.service
	systemd_dounit "${FILESDIR}"/${PN}.socket
	systemd_dounit "${FILESDIR}"/${PN}.service-r1
}
