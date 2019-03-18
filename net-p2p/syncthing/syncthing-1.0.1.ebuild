# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/${PN}/${PN}"

inherit golang-vcs-snapshot systemd user xdg-utils

DESCRIPTION="Open Source Continuous File Synchronization"
HOMEPAGE="https://syncthing.net"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="selinux tools"

RDEPEND="selinux? ( sec-policy/selinux-syncthing )"

DOCS=( README.md AUTHORS CONTRIBUTING.md )

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}

	if use tools ; then
		# separate user for the relay server
		enewgroup strelaysrv
		enewuser strelaysrv -1 -1 /var/lib/strelaysrv strelaysrv
		# and his home folder
		keepdir /var/lib/strelaysrv
		fowners strelaysrv:strelaysrv /var/lib/strelaysrv
	fi
}

src_prepare() {
	# Bug #679280
	xdg_environment_reset

	default
	sed -i \
		's|^ExecStart=.*|ExecStart=/usr/libexec/syncthing/strelaysrv|' \
		src/${EGO_PN}/cmd/strelaysrv/etc/linux-systemd/strelaysrv.service \
		|| die
}

src_compile() {
	export GOPATH="${S}:$(get_golibdir_gopath)"
	cd src/${EGO_PN} || die
	go run build.go -version "v${PV}" -no-upgrade install \
		$(usex tools "all" "") || die "build failed"
}

src_test() {
	cd src/${EGO_PN} || die
	go run build.go test || die "test failed"
}

src_install() {
	pushd src/${EGO_PN} >& /dev/null || die
	doman man/*.[157]
	einstalldocs

	dobin bin/syncthing
	if use tools ; then
		exeinto /usr/libexec/syncthing
		local exe
		for exe in bin/* ; do
			[[ "${exe}" == "bin/syncthing" ]] || doexe "${exe}"
		done
	fi
	popd >& /dev/null || die

	# openrc and systemd service files
	systemd_dounit src/${EGO_PN}/etc/linux-systemd/system/${PN}{@,-resume}.service
	systemd_douserunit src/${EGO_PN}/etc/linux-systemd/user/${PN}.service
	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	newinitd "${FILESDIR}/${PN}.initd" ${PN}

	keepdir /var/{lib,log}/${PN}
	fowners ${PN}:${PN} /var/{lib,log}/${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	if use tools ; then
		# openrc and systemd service files
		systemd_dounit src/${EGO_PN}/cmd/strelaysrv/etc/linux-systemd/strelaysrv.service
		newconfd "${FILESDIR}/strelaysrv.confd" strelaysrv
		newinitd "${FILESDIR}/strelaysrv.initd" strelaysrv

		insinto /etc/logrotate.d
		newins "${FILESDIR}/strelaysrv.logrotate" strelaysrv
	fi
}
