# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop go-module systemd xdg-utils

DESCRIPTION="Open Source Continuous File Synchronization"
HOMEPAGE="https://syncthing.net"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${PN}-source-v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 CC0-1.0 ISC MIT MPL-2.0 Unlicense"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ppc64 ~riscv ~x86"
IUSE="selinux tools"

RDEPEND="acct-group/syncthing
	acct-user/syncthing
	tools? ( >=acct-user/stdiscosrv-1
		>=acct-user/strelaysrv-1 )
	selinux? ( sec-policy/selinux-syncthing )"
BDEPEND=">=dev-lang/go-1.20.0"

DOCS=( README.md AUTHORS CONTRIBUTING.md )

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.4-TestIssue5063_timeout.patch
	"${FILESDIR}"/${PN}-1.18.4-tool_users.patch
	"${FILESDIR}"/${PN}-1.27.4-tests_race.patch
)

S="${WORKDIR}"/${PN}

src_prepare() {
	# Bug #679280
	xdg_environment_reset

	default
	sed -i \
		's|^ExecStart=.*|ExecStart=/usr/libexec/syncthing/stdiscosrv|' \
		cmd/stdiscosrv/etc/linux-systemd/stdiscosrv.service \
		|| die
	sed -i \
		's|^ExecStart=.*|ExecStart=/usr/libexec/syncthing/strelaysrv|' \
		cmd/strelaysrv/etc/linux-systemd/strelaysrv.service \
		|| die
}

src_compile() {
	GOARCH= go run build.go -version "v${PV}" -no-upgrade -build-out=bin/ \
		${GOARCH:+-goarch="${GOARCH}"} \
		build $(usex tools "all" "") || die "build failed"
}

src_test() {
	go run build.go test || die "test failed"
}

src_install() {
	local icon_size

	doman man/*.[157]
	einstalldocs

	dobin bin/syncthing

	domenu etc/linux-desktop/*.desktop
	for icon_size in 32 64 128 256 512; do
		newicon -s ${icon_size} assets/logo-${icon_size}.png ${PN}.png
	done
	newicon -s scalable assets/logo-only.svg ${PN}.svg

	if use tools; then
		exeinto /usr/libexec/syncthing
		local exe
		for exe in bin/* ; do
			[[ "${exe}" == "bin/syncthing" ]] || doexe "${exe}"
		done
	fi

	systemd_dounit etc/linux-systemd/system/${PN}{@,-resume}.service
	systemd_douserunit etc/linux-systemd/user/${PN}.service
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.initd-r2 ${PN}

	keepdir /var/log/${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN}

	if use tools; then
		systemd_dounit cmd/stdiscosrv/etc/linux-systemd/stdiscosrv.service
		newconfd "${FILESDIR}"/stdiscosrv.confd stdiscosrv
		newinitd "${FILESDIR}"/stdiscosrv.initd-r1 stdiscosrv

		systemd_dounit cmd/strelaysrv/etc/linux-systemd/strelaysrv.service
		newconfd "${FILESDIR}"/strelaysrv.confd strelaysrv
		newinitd "${FILESDIR}"/strelaysrv.initd-r1 strelaysrv

		insinto /etc/logrotate.d
		newins "${FILESDIR}"/stdiscosrv.logrotate strelaysrv
		newins "${FILESDIR}"/strelaysrv.logrotate strelaysrv
	fi
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
