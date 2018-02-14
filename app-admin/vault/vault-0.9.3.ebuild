# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit fcaps golang-base golang-vcs-snapshot systemd user

EGO_PN="github.com/hashicorp/${PN}"
DESCRIPTION="A tool for managing secrets"
HOMEPAGE="https://vaultproject.io/"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SLOT="0"
LICENSE="MPL-2.0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT="test"

DEPEND=">=dev-lang/go-1.9:=
	dev-go/gox"

FILECAPS=(
	-m 755 'cap_ipc_lock=+ep' usr/bin/${PN}
)

src_prepare() {
	default
	# Avoid the need to have a git checkout
	sed -e 's:^\(GIT_COMMIT=\).*:\1:' \
		-e 's:^\(GIT_DIRTY=\).*:\1:' \
		-e s:\'\${GIT_COMMIT}\${GIT_DIRTY}\':: \
		-i src/${EGO_PN}/scripts/build.sh || die
	sed -e "/hooks/d" -i src/${EGO_PN}/Makefile || die
}

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_compile() {
	mkdir bin || die
	export GOPATH=${S}
	cd src/${EGO_PN} || die
	XC_ARCH=$(go env GOARCH) \
	XC_OS=$(go env GOOS) \
	XC_OSARCH=$(go env GOOS)/$(go env GOARCH) \
	emake
}

src_install() {
	dodoc src/${EGO_PN}/{CHANGELOG.md,CONTRIBUTING.md,README.md}
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"

	keepdir /etc/${PN}.d
	insinto /etc/${PN}.d
	doins "${FILESDIR}/"*.json.example

	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}

	dobin bin/${PN}
}
