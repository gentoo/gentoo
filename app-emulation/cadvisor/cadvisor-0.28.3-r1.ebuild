# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN="github.com/google/cadvisor"

inherit user golang-build golang-vcs-snapshot
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
COMMIT="1e567c2"
KEYWORDS="~amd64"

DESCRIPTION="Analyzes resource usage and performance characteristics of running containers"
HOMEPAGE="https://github.com/google/cadvisor"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /dev/null ${PN}
}

src_prepare() {
	sed -i -e "/go get/d" src/${EGO_PN}/build/assets.sh || die
	sed -i -e "s/git describe.*/echo ${PV} )/"\
		-e "s/git rev-parse --short HEAD.*/echo ${COMMIT} )/"\
		src/${EGO_PN}/build/build.sh || die
	default
}

src_compile() {
	pushd "src/${EGO_PN}"
	GO_FLAGS="-v -work -x" VERBOSE="true" GOPATH="${S}:$(get_golibdir_gopath)" emake build
	popd || die
}

src_install() {
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	dobin src/${EGO_PN}/${PN}
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
}
