# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

EGO_PN="github.com/syncthing/syncthing"
EGIT_COMMIT=v${PV}

inherit golang-vcs-snapshot systemd user versionator

DESCRIPTION="Open Source Continuous File Synchronization"
HOMEPAGE="https://syncthing.net"
SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE=""

DEPEND=""
RDEPEND=""

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}
}

src_compile() {
	export GOPATH="${S}:$(get_golibdir_gopath)"
	cd src/${EGO_PN}
	go run build.go -version "v${PV}" -no-upgrade || die "build failed"
}

src_test() {
	cd src/${EGO_PN}
	go run build.go test || die "test failed"
}

src_install() {
	cd src/${EGO_PN}
	doman man/*.[157]
	dobin bin/*
	dodoc README.md AUTHORS CONTRIBUTING.md
	systemd_dounit "${S}"/src/${EGO_PN}/etc/linux-systemd/system/${PN}@.service \
		"${S}"/src/${EGO_PN}/etc/linux-systemd/system/${PN}-resume.service
	systemd_douserunit "${S}"/src/${EGO_PN}/etc/linux-systemd/user/${PN}.service
	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	keepdir /var/{lib,log}/${PN}
	fowners ${PN}:${PN} /var/{lib,log}/${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" ${PN}
}

pkg_postinst() {
	if [[ $(get_version_component_range 2) -gt \
			$(get_version_component_range 2 ${REPLACING_VERSIONS}) ]]; then
		ewarn "Version ${PV} is not protocol-compatible with version" \
			"0.$(($(get_version_component_range 2) - 1)).x or lower."
		ewarn "Make sure all your devices are running at least version" \
			"0.$(get_version_component_range 2).0."
	fi
}
