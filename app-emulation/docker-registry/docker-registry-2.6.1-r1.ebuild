# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit golang-vcs-snapshot systemd user

KEYWORDS="~amd64"
EGO_PN="github.com/docker/distribution/..."
EGIT_COMMIT="v${PV}"
SRC_URI="https://${EGO_PN%/*}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="Docker Registry 2.0"
HOMEPAGE="https://github.com/docker/distribution"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
SVCNAME=registry

PATCHES=( "${FILESDIR}/${P}-notifications-expvar.patch" )

pkg_setup() {
	enewgroup ${SVCNAME}
	enewuser ${SVCNAME} -1 -1 /dev/null ${SVCNAME}
}

src_compile() {
	GOPATH="${S}" \
		go install -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}" || die
}

src_install() {
	exeinto /usr/libexec/${PN}
	doexe bin/*
	insinto /etc/docker/registry
	newins src/${EGO_PN%/*}/cmd/registry/config-example.yml config.yml.example
	newinitd "${FILESDIR}/${SVCNAME}.initd" "${SVCNAME}"
	newconfd "${FILESDIR}/${SVCNAME}.confd" "${SVCNAME}"
	systemd_dounit "${FILESDIR}/${SVCNAME}.service"
	keepdir /var/{lib,log}/${SVCNAME}
	fowners ${SVCNAME}:${SVCNAME} /var/{lib,log}/${SVCNAME}
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${SVCNAME}.logrotated" "${SVCNAME}"
}
