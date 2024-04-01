# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Sonarr is a Smart PVR for newsgroup and bittorrent users"
HOMEPAGE="https://www.sonarr.tv"

SRC_URI="
	amd64? (
		elibc_glibc? (
			https://github.com/Sonarr/Sonarr/releases/download/v${PV}/Sonarr.main.${PV}.linux-x64.tar.gz
		)
		elibc_musl? (
			https://github.com/Sonarr/Sonarr/releases/download/v${PV}/Sonarr.main.${PV}.linux-musl-x64.tar.gz
		)
	)
	arm? (
		elibc_glibc? (
			https://github.com/Sonarr/Sonarr/releases/download/v${PV}/Sonarr.main.${PV}.linux-arm.tar.gz
		)
	)
	arm64? (
		elibc_glibc? (
			https://github.com/Sonarr/Sonarr/releases/download/v${PV}/Sonarr.main.${PV}.linux-arm64.tar.gz
		)
		elibc_musl? (
			https://github.com/Sonarr/Sonarr/releases/download/v${PV}/Sonarr.main.${PV}.linux-musl-arm64.tar.gz
		)
	)
"
S="${WORKDIR}/Sonarr"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="bindist strip test"

RDEPEND="
	acct-group/sonarr
	acct-user/sonarr
	media-video/mediainfo
	dev-libs/icu
	dev-util/lttng-ust:0
	dev-db/sqlite
"

QA_PREBUILT="*"

src_prepare() {
	default

	# https://github.com/dotnet/runtime/issues/57784
	rm libcoreclrtraceptprovider.so Sonarr.Update/libcoreclrtraceptprovider.so || die
}

src_install() {
	newinitd "${FILESDIR}/sonarr.init-r2" sonarr

	keepdir /var/lib/sonarr
	fowners -R sonarr:sonarr /var/lib/sonarr

	insinto /etc/logrotate.d
	insopts -m0644 -o root -g root
	newins "${FILESDIR}/sonarr.logrotate" sonarr

	dodir  "/opt/sonarr"
	cp -R "${S}/." "${D}/opt/sonarr" || die "Install failed!"

	systemd_newunit "${FILESDIR}/sonarr.service-r1" "sonarr.service"
	systemd_newunit "${FILESDIR}/sonarr.service-r1" "sonarr@.service"
}
