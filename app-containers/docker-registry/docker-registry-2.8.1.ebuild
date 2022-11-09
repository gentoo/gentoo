# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-vcs-snapshot systemd

EGIT_COMMIT="b5ca020cfbe998e5af3457fda087444cf5116496"
EGO_PN="github.com/docker/distribution"

DESCRIPTION="Docker Registry 2.0"
HOMEPAGE="https://github.com/docker/distribution"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 MIT ZLIB"
SLOT="0"
KEYWORDS="amd64 ~arm64"

DEPEND="
	acct-group/registry
	acct-user/registry
"
RDEPEND="${DEPEND}"

SVCNAME="registry"

src_prepare() {
	default
	pushd src/${EGO_PN} || die
	eapply "${FILESDIR}"/${PN}-2.7.0-notification-metrics.patch
	sed -e "s/git describe.*/echo ${PV})/" \
		-e "s/git rev-parse.*/echo ${EGIT_COMMIT})/" \
		-e "s/-s -w/-w/" \
		-i Makefile || die
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
	keepdir /var/log/${SVCNAME}
	fowners ${SVCNAME}:${SVCNAME} /var/log/${SVCNAME}
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${SVCNAME}.logrotated" "${SVCNAME}"
}
