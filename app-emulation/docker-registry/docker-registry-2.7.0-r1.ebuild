# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit golang-vcs-snapshot systemd user

KEYWORDS="~amd64"
EGO_PN="github.com/docker/distribution"
EGIT_COMMIT="v${PV}"
SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="Docker Registry 2.0"
HOMEPAGE="https://github.com/docker/distribution"
LICENSE="Apache-2.0"
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
	eapply "${FILESDIR}"/${P}-notification-metrics.patch
	popd || die
}

src_compile() {
	export -n GOCACHE XDG_CACHE_HOME #681072
	GOPATH="${S}" \
		go install -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}/..." || die
}

src_install() {
	exeinto /usr/libexec/${PN}
	doexe bin/*
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
