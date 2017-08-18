# Copyright 1999-2017 Gentoo Foundation
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
	KEYWORDS="~amd64"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="
	app-arch/zip
	>=dev-lang/go-1.7"
RDEPEND=""

src_compile() {
	BUILDFLAGS="" GOPATH="${S}" emake -C src/${EGO_PN%/*}
	pushd src/${EGO_PN%/*}/web/dist >/dev/null || die
	zip -qr "${S}/src/${EGO_PN%/*}/build/webassets.zip" . || die
	popd >/dev/null || die
	cat "${S}/src/${EGO_PN%/*}/build/webassets.zip" >> "src/${EGO_PN%/*}/build/${PN}" || die
	zip -q -A "${S}/src/${EGO_PN%/*}/build/${PN}" || die
}

src_install() {
	dodir /var/lib/${PN} /etc/${PN}
	dobin src/${EGO_PN%/*}/build/{tsh,tctl,teleport}

	insinto /etc/${PN}
	doins "${FILESDIR}"/${PN}.yaml

	newinitd "${FILESDIR}"/${PN}.init.d ${PN}
	newconfd "${FILESDIR}"/${PN}.conf.d ${PN}

	systemd_dounit "${FILESDIR}"/${PN}.service
	systemd_install_serviced "${FILESDIR}"/${PN}.service.conf ${PN}.service
}
