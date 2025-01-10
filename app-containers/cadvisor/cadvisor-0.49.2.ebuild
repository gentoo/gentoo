# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

COMMIT=6876475afe3755d62b65df0d32b005047fc69377

DESCRIPTION="Analyzes resource usage and performance characteristics of running containers"
HOMEPAGE="https://github.com/google/cadvisor"
SRC_URI="https://github.com/google/cadvisor/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~arthurzam/distfiles/app-containers/${PN}/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 ISC MIT"
SLOT="0"
KEYWORDS="~amd64"

COMMON_DEPEND="acct-group/cadvisor
	acct-user/cadvisor"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

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
	newinitd "${FILESDIR}"/${PN}.initd-r1 ${PN}
	systemd_dounit "${FILESDIR}/${PN}.service"
	dobin _output/${PN}
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
}
