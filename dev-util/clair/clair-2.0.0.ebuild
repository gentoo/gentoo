# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit user golang-build golang-vcs-snapshot

EGO_PN="github.com/coreos/clair"
EGIT_COMMIT="v${PV}"
ARCHIVE_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Vulnerability Static Analysis for Containers"
HOMEPAGE="https://github.com/coreos/clair"
SRC_URI="${ARCHIVE_URI}"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="app-arch/rpm
	app-arch/xz-utils
	dev-vcs/bzr
	dev-vcs/git
	!!sci-visualization/xd3d" # File collision (Bug #621044)

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_compile() {
	GOPATH="${S}" go build -o bin/${PN} -v ${EGO_PN}/cmd/${PN}  || die
}

src_install() {
	dobin bin/${PN}
	pushd src/${EGO_PN} || die
	dodoc {README,ROADMAP,CONTRIBUTING}.md
	insinto /etc/${PN}
	doins config.example.yaml
	popd || die

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
}
