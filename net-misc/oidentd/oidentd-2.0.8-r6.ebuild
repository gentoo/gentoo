# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-info systemd

DESCRIPTION="Another (RFC1413 compliant) ident daemon"
HOMEPAGE="https://oidentd.janikrabe.com/"
SRC_URI="mirror://sourceforge/ojnk/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh ~sparc x86"
IUSE="debug ipv6 masquerade selinux"

DEPEND=""

RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-oident )"

DOCS=( AUTHORS ChangeLog README TODO NEWS "${FILESDIR}"/${PN}_masq.conf "${FILESDIR}"/${PN}.conf )

PATCHES=(
	"${FILESDIR}/${P}-masquerading.patch"
	"${FILESDIR}/${P}-bind-to-ipv6-too.patch"
	"${FILESDIR}/${P}-gcc5.patch"
	"${FILESDIR}/${P}-log-conntrack-fails.patch"
	"${FILESDIR}/${P}-no-conntrack-masquerading.patch"
)

pkg_setup() {
	local CONFIG_CHECK="~INET_TCP_DIAG"

	if use kernel_linux; then
		linux-info_pkg_setup
	fi
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable ipv6) \
		$(use_enable masquerade masq) \
		$(use_enable masquerade nat)
}

src_install() {
	default

	newinitd "${FILESDIR}"/${PN}-2.0.7-init ${PN}
	newconfd "${FILESDIR}"/${PN}-2.0.7-confd ${PN}

	systemd_newunit "${FILESDIR}"/${PN}_at.service ${PN}@.service
	systemd_dounit "${FILESDIR}"/${PN}.socket
	systemd_dounit "${FILESDIR}"/${PN}.service
}

pkg_postinst() {
	echo
	elog "Example configuration files are in /usr/share/doc/${PF}"
	echo
}
