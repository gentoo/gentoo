# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module
COMMIT=4fe450a23991beb6c61dc941c0f87f56021ad386

DESCRIPTION="Analyzes resource usage and performance characteristics of running containers"
HOMEPAGE="https://github.com/google/cadvisor"
SRC_URI="https://github.com/google/cadvisor/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 ISC MIT"
KEYWORDS="~amd64"
SLOT="0"

COMMON_DEPEND="acct-group/cadvisor
	acct-user/cadvisor"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

src_prepare() {
	sed -i -e "/go get/d" build/assets.sh || die
	sed -i -e "s/git describe.*/echo ${PV} )/"\
		-e "s/git rev-parse --short HEAD.*/echo ${COMMIT} )/"\
		build/build.sh || die
	default
}

src_compile() {
	rm -fr vendor || die
	GO_FLAGS="${GOFLAGS}" VERBOSE="true" emake build
}

src_install() {
	newinitd "${FILESDIR}"/${PN}.initd-r1 ${PN}
	dobin ${PN}
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
}
