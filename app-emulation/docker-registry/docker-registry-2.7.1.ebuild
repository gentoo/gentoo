# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit golang-vcs-snapshot systemd user

KEYWORDS="~amd64"
EGO_PN="github.com/docker/distribution"
EGIT_COMMIT="2461543d988979529609e8cb6fca9ca190dc48da"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="Docker Registry 2.0"
HOMEPAGE="https://github.com/docker/distribution"
LICENSE="Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 MIT ZLIB"
SLOT="0"
IUSE=""
SVCNAME=registry

pkg_setup() {
	enewgroup ${SVCNAME}
	enewuser ${SVCNAME} -1 -1 /dev/null ${SVCNAME}
}

src_prepare() {
	default
	pushd src/${EGO_PN} || die
	eapply "${FILESDIR}"/${PN}-2.7.0-notification-metrics.patch
	sed -i -e "s/git describe.*/echo ${PV})/"\
		-e "s/git rev-parse.*/echo ${EGIT_COMMIT})/"\
		-e "s/-s -w/-w/" Makefile || die
	popd || die
}

src_compile() {
	export -n GOCACHE XDG_CACHE_HOME #681072
	GOPATH="${S}" GO_BUILD_FLAGS="-v" emake -C src/${EGO_PN} binaries
}

src_install() {
	exeinto /usr/libexec/${PN}
	doexe src/${EGO_PN}/bin/*
	insinto /etc/docker/registry
	newins src/${EGO_PN}/cmd/registry/config-example.yml config.yml.example
	newinitd "${FILESDIR}/${SVCNAME}.initd" "${SVCNAME}"
	newconfd "${FILESDIR}/${SVCNAME}.confd" "${SVCNAME}"
	systemd_dounit "${FILESDIR}/${SVCNAME}.service"
	keepdir /var/{lib,log}/${SVCNAME}
	fowners ${SVCNAME}:${SVCNAME} /var/{lib,log}/${SVCNAME}
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${SVCNAME}.logrotated" "${SVCNAME}"
}
