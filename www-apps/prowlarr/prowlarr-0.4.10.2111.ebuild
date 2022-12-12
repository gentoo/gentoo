# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

SRC_URI="
	amd64? ( https://github.com/Prowlarr/Prowlarr/releases/download/v${PV}/Prowlarr.develop.${PV}.linux-core-x64.tar.gz )
	arm? ( https://github.com/Prowlarr/Prowlarr/releases/download/v${PV}/Prowlarr.develop.${PV}.linux-core-arm.tar.gz )
	arm64? ( https://github.com/Prowlarr/Prowlarr/releases/download/v${PV}/Prowlarr.develop.${PV}.linux-core-arm64.tar.gz )
"

DESCRIPTION="An indexer manager/proxy to integrate with your various PVR apps"
HOMEPAGE="https://wiki.servarr.com/prowlarr"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm ~arm64"
RESTRICT="bindist strip test"

RDEPEND="
	acct-group/prowlarr
	acct-user/prowlarr
	dev-libs/icu
	dev-util/lttng-ust:0
	dev-db/sqlite
	sys-libs/glibc
"

QA_PREBUILT="*"

S="${WORKDIR}/Prowlarr"

src_prepare() {
	default

	# https://github.com/dotnet/runtime/issues/57784
	rm libcoreclrtraceptprovider.so Prowlarr.Update/libcoreclrtraceptprovider.so || die
}

src_install() {
	newinitd "${FILESDIR}/${PN}.init" ${PN}

	keepdir /var/lib/${PN}
	fowners -R ${PN}:${PN} /var/lib/${PN}

	insinto /etc/logrotate.d
	insopts -m0644 -o root -g root
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	dodir  "/opt/${PN}"
	cp -R "${S}/." "${D}/opt/prowlarr" || die "Install failed!"

	systemd_dounit "${FILESDIR}/prowlarr.service"
	systemd_newunit "${FILESDIR}/prowlarr.service" "${PN}@.service"
}
