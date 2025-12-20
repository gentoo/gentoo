# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

COMMIT=85d18c6139a3f1fd48120c49ae44eac5aa352d86

DESCRIPTION="Analyzes resource usage and performance characteristics of running containers"
HOMEPAGE="https://github.com/google/cadvisor"
SRC_URI="https://github.com/google/cadvisor/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/${PN}/releases/download/v${PV}/${P}-deps.tar.xz"

LICENSE="Apache-2.0"
# Dependent licenses
LICENSE+=" Apache-2.0 BSD BSD-2 ISC MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	acct-group/cadvisor
	acct-user/cadvisor
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -i build/assets.sh -e "/go install/d"  || die
	sed -i build/build.sh \
		-e "/^version=/s/=.*/=${PV}/" \
		-e "/^revision=/s/=.*/=${COMMIT}/" \
		-e "/^branch=/s/=.*/=v${PV}/" || die
}

src_compile() {
	GO_FLAGS="${GOFLAGS}" VERBOSE="true" emake build
}

src_test() {
	GO_FLAGS="${GOFLAGS}" VERBOSE="true" emake test
}

src_install() {
	dobin _output/${PN}

	newinitd "${FILESDIR}"/${PN}.initd-r2 ${PN}
	systemd_dounit "${FILESDIR}/${PN}.service"

	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
}
