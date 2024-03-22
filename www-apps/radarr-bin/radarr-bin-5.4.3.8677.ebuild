# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="A fork of Sonarr to work with movies a la Couchpotato"
HOMEPAGE="https://www.radarr.video/
	https://github.com/Radarr/Radarr/"

SRC_URI="
	amd64? (
		elibc_glibc? (
			https://github.com/Radarr/Radarr/releases/download/v${PV}/Radarr.develop.${PV}.linux-core-x64.tar.gz
		)
		elibc_musl? (
			https://github.com/Radarr/Radarr/releases/download/v${PV}/Radarr.develop.${PV}.linux-musl-core-x64.tar.gz
		)
	)
	arm? (
		elibc_glibc? (
			https://github.com/Radarr/Radarr/releases/download/v${PV}/Radarr.develop.${PV}.linux-core-arm.tar.gz
		)
		elibc_musl? (
			https://github.com/Radarr/Radarr/releases/download/v${PV}/Radarr.develop.${PV}.linux-musl-core-arm.tar.gz
		)
	)
	arm64? (
		elibc_glibc? (
			https://github.com/Radarr/Radarr/releases/download/v${PV}/Radarr.develop.${PV}.linux-core-arm64.tar.gz
		)
		elibc_musl? (
			https://github.com/Radarr/Radarr/releases/download/v${PV}/Radarr.develop.${PV}.linux-musl-core-arm64.tar.gz
		)
	)
"
S="${WORKDIR}/Radarr"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="bindist strip test"

RDEPEND="
	acct-group/radarr
	acct-user/radarr
	media-video/mediainfo
	dev-libs/icu
	dev-util/lttng-ust:0
	dev-db/sqlite
"

QA_PREBUILT="*"

src_prepare() {
	default

	# https://github.com/dotnet/runtime/issues/57784
	rm libcoreclrtraceptprovider.so Radarr.Update/libcoreclrtraceptprovider.so || die
}

src_install() {
	newinitd "${FILESDIR}/jellyfin.init" jellyfin

	keepdir /var/lib/jellyfin
	fowners -R jellyfin:jellyfin /var/lib/jellyfin

	insinto /etc/logrotate.d
	insopts -m0644 -o root -g root
	newins "${FILESDIR}/jellyfin.logrotate" jellyfin

	dodir  "/opt/jellyfin"
	cp -R "${S}/." "${D}/opt/radarr" || die "Install failed!"

	systemd_dounit "${FILESDIR}/radarr.service"
	systemd_newunit "${FILESDIR}/radarr.service" "jellyfin@.service"
}
