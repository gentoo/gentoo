# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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

DEPEND=">=dev-lang/go-1.3:=
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

	insinto /etc/${PN}
	newins "${PN}".conf.sample "${PN}".conf
}
