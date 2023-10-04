# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A modern client-server application for the Soulseek file sharing network."
HOMEPAGE="https://github.com/slskd/slskd"

inherit git-r3 pax-utils systemd
EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"

if [[ "$PV" != *9999 ]]; then
	EGIT_COMMIT="${PV}"
fi

# network-sandbox - needs an NPM eclass to downloads deps, doesn't currently exist.
# strip - binary doesn't need stripping as it's a package
RESTRICT="mirror network-sandbox strip"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~arm"
DEPEND="acct-user/slskd
virtual/dotnet-sdk
net-libs/nodejs[npm]
sys-apps/coreutils"

src_compile() {
	if use amd64; then
		arch="x64"
	elif use arm64; then
		arch="arm64"
	elif use arm; then
		arch="arm"
	fi

	./bin/publish --runtime linux-${arch}
}

src_install() {
	insinto "/opt/slskd"
	doins -r "dist/linux-${arch}"/*
	insinto "/opt/slskd/config"
	newins "dist/linux-${arch}/config/slskd.example.yml" "slskd.yml"

	newinitd "${FILESDIR}/${PN}.init-r1" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"

	chmod 755 "${D}/opt/slskd/slskd"
	pax-mark -m "${D}/opt/slskd/slskd"
}

pkg_postinst() {
	. "${EROOT}"/etc/conf.d/slskd &>/dev/null

	elog "Static web content is stored below."
	elog
	elog "${SLSKD_WWWROOT}"
	elog
	elog "Ensure the default username and password has been"
	elog "changed in the configuration, for both the panel"
	elog "and slsk. Configuration is stored in path below."
	elog
	elog "${SLSKD_CONFIG}"
	elog
	elog "Ensure you configure and run slskd within your"
	elog "init system."
}
