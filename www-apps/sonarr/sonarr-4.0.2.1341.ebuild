# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

SRC_URI="
	amd64? (
		elibc_glibc? ( https://github.com/Sonarr/Sonarr/releases/download/v${PV}/Sonarr.develop.${PV}.linux-x64.tar.gz )
		elibc_musl? ( https://github.com/Sonarr/Sonarr/releases/download/v${PV}/Sonarr.develop.${PV}.linux-musl-x64.tar.gz )
	)
	arm? (
		elibc_glibc? ( https://github.com/Sonarr/Sonarr/releases/download/v${PV}/Sonarr.develop.${PV}.linux-arm.tar.gz )
	)
	arm64? (
		elibc_glibc? ( https://github.com/Sonarr/Sonarr/releases/download/v${PV}/Sonarr.develop.${PV}.linux-arm64.tar.gz )
		elibc_musl? ( https://github.com/Sonarr/Sonarr/releases/download/v${PV}/Sonarr.develop.${PV}.linux-musl-arm64.tar.gz )
	)
"

DESCRIPTION="Sonarr is a Smart PVR for newsgroup and bittorrent users"
HOMEPAGE="https://www.sonarr.tv"

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

S="${WORKDIR}/Sonarr"

src_prepare() {
	default

	# https://github.com/dotnet/runtime/issues/57784
	rm libcoreclrtraceptprovider.so Sonarr.Update/libcoreclrtraceptprovider.so || die
}

src_install() {
	newinitd "${FILESDIR}/${PN}.init-r2" ${PN}

	keepdir /var/lib/${PN}
	fowners -R ${PN}:${PN} /var/lib/${PN}

	insinto /etc/logrotate.d
	insopts -m0644 -o root -g root
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	dodir  "/opt/${PN}"
	cp -R "${S}/." "${D}/opt/sonarr" || die "Install failed!"

	systemd_newunit "${FILESDIR}/${PN}.service-r1" "${PN}.service"
	systemd_newunit "${FILESDIR}/${PN}.service-r1" "${PN}@.service"
}
