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
IUSE="tools"

DOCS="README.md AUTHORS CONTRIBUTING.md"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}

	if use tools ; then
		# separate user for relaysrv
		enewgroup ${PN}-relaysrv
		enewuser ${PN}-relaysrv -1 -1 /var/lib/${PN}-relaysrv ${PN}-relaysrv
	fi
}

src_prepare() {
	default
	sed -i \
		's|^ExecStart=.*|ExecStart=/usr/libexec/syncthing/relaysrv|' \
		src/${EGO_PN}/cmd/strelaysrv/etc/linux-systemd/strelaysrv.service \
		|| die
}

src_compile() {
	export GOPATH="${S}:$(get_golibdir_gopath)"
	cd src/${EGO_PN} || die
	# If we pass "build" to build.go, it builds only syncthing itself, and
	# places the binary in the root folder. If we do not pass "build", all the
	# tools are built, and all binaries are placed in folder ./bin.
	ST_BUILD="build"
	if use tools ; then
		ST_BUILD=""
	fi
	go run build.go -version "v${PV}" -no-upgrade ${ST_BUILD} || die "build failed"
}

src_test() {
	cd src/${EGO_PN} || die
	go run build.go test || die "test failed"
}

src_install() {
	cd src/${EGO_PN} || die
	doman man/*.[157]

	if use tools ; then
		dobin bin/syncthing
		exeinto /usr/libexec/syncthing
		for exe in bin/* ; do
			[ "${exe}" = "bin/syncthing" ] || doexe "${exe}"
		done
	else
		dobin syncthing
	fi

	# openrc and systemd service files
	systemd_dounit "${S}"/src/${EGO_PN}/etc/linux-systemd/system/${PN}@.service \
		"${S}"/src/${EGO_PN}/etc/linux-systemd/system/${PN}-resume.service
	systemd_douserunit "${S}"/src/${EGO_PN}/etc/linux-systemd/user/${PN}.service
	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	newinitd "${FILESDIR}/${PN}.initd" ${PN}

	keepdir /var/{lib,log}/${PN}
	fowners ${PN}:${PN} /var/{lib,log}/${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	if use tools ; then
		# openrc and systemd service files
		systemd_dounit "${S}"/src/${EGO_PN}/cmd/strelaysrv/etc/linux-systemd/strelaysrv.service
		newconfd "${FILESDIR}/${PN}-relaysrv.confd" ${PN}-relaysrv
		newinitd "${FILESDIR}/${PN}-relaysrv.initd" ${PN}-relaysrv

		keepdir /var/lib/${PN}-relaysrv
		fowners ${PN}-relaysrv:${PN}-relaysrv /var/{lib,log}/${PN}

		insinto /etc/logrotate.d
		newins "${FILESDIR}/syncthing-relaysrv.logrotate" syncthing-relaysrv
	fi
}

pkg_postinst() {
	local v
    for v in ${REPLACING_VERSIONS}; do
		if [[ $(get_version_component_range 2) -gt \
				$(get_version_component_range 2 ${v}) ]]; then
			ewarn "Version ${PV} is not protocol-compatible with version" \
				"0.$(($(get_version_component_range 2) - 1)).x or lower."
			ewarn "Make sure all your devices are running at least version" \
				"0.$(get_version_component_range 2).0."
		fi
	done
}
