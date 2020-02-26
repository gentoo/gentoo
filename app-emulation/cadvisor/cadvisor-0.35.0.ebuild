# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
EGO_PN="github.com/google/cadvisor"
COMMIT=49033161
inherit golang-build golang-vcs-snapshot

DESCRIPTION="Analyzes resource usage and performance characteristics of running containers"
HOMEPAGE="https://github.com/google/cadvisor"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 ISC MIT"
KEYWORDS="~amd64"
SLOT="0"

COMMON_DEPEND="acct-group/cadvisor
	acct-user/cadvisor"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

src_prepare() {
	sed -i -e "/go get/d" src/${EGO_PN}/build/assets.sh || die
	sed -i -e "s/git describe.*/echo ${PV} )/"\
		-e "s/git rev-parse --short HEAD.*/echo ${COMMIT} )/"\
		src/${EGO_PN}/build/build.sh || die
	default
}

src_compile() {
	export -n GOCACHE XDG_CACHE_HOME
	pushd "src/${EGO_PN}"
	GO_FLAGS="-v -work -x" VERBOSE="true" GOPATH="${S}:$(get_golibdir_gopath)" emake build
	popd || die
}

src_install() {
	newinitd "${FILESDIR}"/${PN}.initd-r1 ${PN}
	dobin src/${EGO_PN}/${PN}
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
}
