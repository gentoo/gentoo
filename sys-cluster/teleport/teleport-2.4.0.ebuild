# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils golang-build systemd user

DESCRIPTION="Modern SSH server for teams managing distributed infrastructure"
HOMEPAGE="https://gravitational.com/teleport"

EGO_PN="github.com/gravitational/${PN}/..."

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3 golang-vcs
	EGIT_REPO_URI="https://github.com/gravitational/${PN}.git"
else
	inherit golang-vcs-snapshot
	SRC_URI="https://github.com/gravitational/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm"
fi

IUSE=""
LICENSE="Apache-2.0"
RESTRICT="test strip"
SLOT="0"

DEPEND="
	app-arch/zip
	>=dev-lang/go-1.8.3"
RDEPEND=""

src_compile() {
	GOPATH="${S}" emake -j1 -C src/${EGO_PN%/*} full
}

src_install() {
	keepdir /var/lib/${PN} /etc/${PN}
	dobin src/${EGO_PN%/*}/build/{tsh,tctl,teleport}

	insinto /etc/${PN}
	doins "${FILESDIR}"/${PN}.yaml

	newinitd "${FILESDIR}"/${PN}.init.d ${PN}
	newconfd "${FILESDIR}"/${PN}.conf.d ${PN}

	systemd_dounit "${FILESDIR}"/${PN}.service
	systemd_install_serviced "${FILESDIR}"/${PN}.service.conf ${PN}.service
}

src_test() {
	BUILDFLAGS="" GOPATH="${S}" emake -C src/${EGO_PN%/*} test
}
