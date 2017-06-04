# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot systemd user

KEYWORDS="~amd64"
DESCRIPTION="Generic template rendering and notifications with Consul"
EGO_PN="github.com/hashicorp/${PN}"
HOMEPAGE="http://${EGO_PN}"
LICENSE="MPL-2.0"
SLOT="0"
IUSE=""

DEPEND=">=dev-lang/go-1.6:="
RDEPEND=""

SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_prepare() {
	eapply_user
	# Avoid the need to have a git checkout
	sed -e 's:^GIT.*::' \
		-i src/${EGO_PN}/scripts/compile.sh || die
}

src_compile() {
	export GOPATH=${S}
	cd "${S}"/src/${EGO_PN} || die
	PATH=${PATH}:${S}/bin \
	XC_ARCH=$(go env GOARCH) \
	XC_OS=$(go env GOOS) \
	emake bin-local
}

src_test() {
	cd "${S}"/src/${EGO_PN} || die
	emake test || die
}

src_install() {
	dobin "${S}"/src/${EGO_PN}/pkg/$(go env GOOS)_$(go env GOARCH)/${PN}
	dodoc "${S}"/src/${EGO_PN}/{CHANGELOG.md,README.md}

	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"

	keepdir /etc/${PN}.d
}
