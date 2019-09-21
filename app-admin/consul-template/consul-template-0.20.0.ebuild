# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot systemd user

KEYWORDS="~amd64"
DESCRIPTION="Generic template rendering and notifications with Consul"
GIT_COMMIT="9a0f301"
EGO_PN="github.com/hashicorp/${PN}"
HOMEPAGE="https://github.com/hashicorp/consul-template"
LICENSE="MPL-2.0 Apache-2.0 BSD BSD-2 ISC MIT WTFPL-2"
SLOT="0"
# TODO: debug test failures
RESTRICT="test"

DEPEND="dev-lang/go"
RDEPEND=""

SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_prepare() {
	default
	# Avoid the need to have a git checkout
	sed -e "s:git rev-parse --short HEAD:echo ${GIT_COMMIT}:" \
		-e '/-s \\/d' \
		-i src/${EGO_PN}/Makefile || die
	# Printf format %q has arg r.config.PidFile of wrong type *string
	sed -e 's|remove pid at %q: %s|remove pid at %v: %s|' \
		-i src/${EGO_PN}/manager/runner.go || die
}

src_compile() {
	export GOPATH=${S}
	cd src/${EGO_PN} || die
	#XC_ARCH=$(go env GOARCH) \
	#XC_OS=$(go env GOOS) \
	emake dev
}

src_test() {
	cd src/${EGO_PN} || die
	emake test
}

src_install() {
	dobin bin/${PN}
	dodoc src/${EGO_PN}/{CHANGELOG.md,README.md}

	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"

	keepdir /etc/${PN}.d
}
