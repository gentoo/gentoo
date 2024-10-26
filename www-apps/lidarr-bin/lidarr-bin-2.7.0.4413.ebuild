# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Looks and smells like Sonarr but made for music"
HOMEPAGE="https://lidarr.audio/
	https://github.com/Lidarr/Lidarr/"

SRC_URI="
	amd64? (
		elibc_glibc? (
			https://github.com/Lidarr/Lidarr/releases/download/v${PV}/Lidarr.develop.${PV}.linux-core-x64.tar.gz
		)
		elibc_musl? (
			https://github.com/Lidarr/Lidarr/releases/download/v${PV}/Lidarr.develop.${PV}.linux-musl-core-x64.tar.gz
		)
	)
	arm? (
		elibc_glibc? (
			https://github.com/Lidarr/Lidarr/releases/download/v${PV}/Lidarr.develop.${PV}.linux-core-arm.tar.gz
		)
		elibc_musl? (
			https://github.com/Lidarr/Lidarr/releases/download/v${PV}/Lidarr.develop.${PV}.linux-musl-core-arm.tar.gz
		)
	)
	arm64? (
		elibc_glibc? (
			https://github.com/Lidarr/Lidarr/releases/download/v${PV}/Lidarr.develop.${PV}.linux-core-arm64.tar.gz
		)
		elibc_musl? (
			https://github.com/Lidarr/Lidarr/releases/download/v${PV}/Lidarr.develop.${PV}.linux-musl-core-arm64.tar.gz
		)
	)
"
S="${WORKDIR}/Lidarr"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="bindist strip test"

RDEPEND="
	acct-group/lidarr
	acct-user/lidarr
	media-video/mediainfo
	dev-libs/icu
	dev-util/lttng-ust:0
	dev-db/sqlite
"

QA_PREBUILT="*"

src_prepare() {
	default

	# https://github.com/dotnet/runtime/issues/57784
	rm libcoreclrtraceptprovider.so Lidarr.Update/libcoreclrtraceptprovider.so || die
}

src_install() {
	newinitd "${FILESDIR}/lidarr.init" lidarr

	keepdir /var/lib/lidarr
	fowners -R lidarr:lidarr /var/lib/lidarr

	insinto /etc/logrotate.d
	insopts -m0644 -o root -g root
	newins "${FILESDIR}/lidarr.logrotate" lidarr

	dodir  "/opt/lidarr"
	cp -R "${S}/." "${D}/opt/lidarr" || die "Install failed!"

	systemd_dounit "${FILESDIR}/lidarr.service"
	systemd_newunit "${FILESDIR}/lidarr.service" "lidarr@.service"
}
