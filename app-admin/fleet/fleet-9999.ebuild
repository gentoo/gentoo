# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/fleet/fleet-9999.ebuild,v 1.7 2015/05/27 05:19:21 zmedico Exp $

EAPI=5

inherit git-r3 systemd

EGIT_REPO_URI="git://github.com/coreos/fleet.git"

DESCRIPTION="A Distributed init System"
HOMEPAGE="https://github.com/coreos/fleet"
SRC_URI=""

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="doc examples test"

DEPEND=">=dev-lang/go-1.3
	test? ( dev-go/go-tools )"
RDEPEND=""

src_compile() {
	./build || die 'Build failed'
}

src_test() {
	./test || die 'Tests failed'
}

src_install() {
	dobin "${S}"/bin/fleetd
	dobin "${S}"/bin/fleetctl

	systemd_dounit "${FILESDIR}"/fleet.service
	systemd_dounit "${FILESDIR}"/fleet.socket

	dodoc README.md
	use doc && dodoc -r Documentation
	use examples && dodoc -r examples

	keepdir /etc/${PN}
	insinto /etc/${PN}
	newins "${PN}".conf.sample "${PN}".conf
}

pkg_postinst() {
	ewarn "Please read this if you are upgrading from a version <0.10.0-r1."
	ewarn ""
	ewarn "Starting with fleet 0.10 the fleetctl utility has"
	ewarn "'--endpoint=unix:///var/run/fleet.sock' as default argument, which is"
	ewarn "why we have introduced the fleet.socket unit and renamed the service"
	ewarn "from fleetd.service to fleet.service. If you run fleet on system"
	ewarn "startup, please re-enable it via 'systemctl enable fleet'."
}
