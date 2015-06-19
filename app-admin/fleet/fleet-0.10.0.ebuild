# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/fleet/fleet-0.10.0.ebuild,v 1.1 2015/04/17 23:30:18 alunduil Exp $

EAPI=5

inherit systemd vcs-snapshot

DESCRIPTION="A Distributed init System"
HOMEPAGE="https://github.com/coreos/fleet"
SRC_URI="https://github.com/coreos/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc examples"

DEPEND=">=dev-lang/go-1.3"
RDEPEND=""

src_compile() {
	./build || die 'Build failed'
}

RESTRICT="test"  # Tests fail due to Gentoo bug #500452
src_test() {
	./test || die 'Tests failed'
}

src_install() {
	dobin "${S}"/bin/fleetd
	dobin "${S}"/bin/fleetctl

	systemd_dounit "${FILESDIR}"/fleetd.service

	dodoc README.md
	use doc && dodoc -r Documentation
	use examples && dodoc -r examples

	keepdir /etc/${PN}
	insinto /etc/${PN}
	newins "${PN}".conf.sample "${PN}".conf
}
