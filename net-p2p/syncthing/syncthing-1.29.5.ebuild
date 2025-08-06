# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop go-module systemd xdg-utils

DESCRIPTION="Open Source Continuous File Synchronization"
HOMEPAGE="https://syncthing.net https://github.com/syncthing/syncthing"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${PN}-source-v${PV}.tar.gz"
S="${WORKDIR}"/${PN}

LICENSE="MPL-2.0 Apache-2.0 BSD BSD-2 CC0-1.0 ISC MIT Unlicense"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc64 ~riscv x86"
IUSE="selinux tools"

RDEPEND="
	acct-group/syncthing
	acct-user/syncthing
	tools? (
		>=acct-user/stdiscosrv-1
		>=acct-user/strelaysrv-1
	)
	selinux? ( sec-policy/selinux-syncthing )
"
BDEPEND=">=dev-lang/go-1.21.0"

DOCS=( AUTHORS {GOALS,README}.md )

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.4-TestIssue5063_timeout.patch
	"${FILESDIR}"/${PN}-1.18.4-tool_users.patch
	"${FILESDIR}"/${PN}-1.29.5-remove_race_in_tests.patch #955442
)

src_prepare() {
	# Bug #679280
	xdg_environment_reset

	default

	local srv
	for srv in st{disco,relay}srv; do
		sed -i \
			's|^ExecStart=.*|ExecStart=/usr/libexec/${PN}/${srv}|' \
			cmd/${srv}/etc/linux-systemd/${srv}.service || die
	done;
}

src_compile() {
	GOARCH= CGO_ENABLED=1 go run build.go -version "v${PV}" -no-upgrade -build-out=bin/ \
		${GOARCH:+-goarch="${GOARCH}"} \
		build $(usev tools all) || die "build failed"
}

src_test() {
	go run build.go test || die "test failed"
}

src_install() {
	dobin bin/${PN}

	doman man/*.[157]
	einstalldocs

	domenu etc/linux-desktop/${PN}-{start,ui}.desktop
	local -i icon_size
	for icon_size in 32 64 128 256 512; do
		newicon -s ${icon_size} assets/logo-${icon_size}.png ${PN}.png
	done
	newicon -s scalable assets/logo-only.svg ${PN}.svg

	systemd_dounit etc/linux-systemd/system/${PN}@.service
	systemd_douserunit etc/linux-systemd/user/${PN}.service
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.initd-r2 ${PN}

	keepdir /var/log/${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN}

	insinto /etc/ufw/applications.d
	doins etc/firewall-ufw/${PN}

	if use tools; then
		exeinto /usr/libexec/${PN}
		insinto /etc/logrotate.d

		local srv
		for srv in st{disco,relay}srv; do
			doexe bin/${srv}
			systemd_dounit cmd/${srv}/etc/linux-systemd/${srv}.service
			newconfd "${FILESDIR}"/${srv}.confd ${srv}
			newinitd "${FILESDIR}"/${srv}.initd-r1 ${srv}

			newins "${FILESDIR}"/${srv}.logrotate ${srv}
		done
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
