# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="An indexer manager/proxy to integrate with your various PVR apps"
HOMEPAGE="https://wiki.servarr.com/prowlarr/
	https://github.com/Prowlarr/Prowlarr/"

SRC_URI="
	amd64? (
		elibc_glibc? (
			https://github.com/Prowlarr/Prowlarr/releases/download/v${PV}/Prowlarr.develop.${PV}.linux-core-x64.tar.gz
		)
		elibc_musl? (
			https://github.com/Prowlarr/Prowlarr/releases/download/v${PV}/Prowlarr.develop.${PV}.linux-musl-core-x64.tar.gz
		)
	)
	arm? (
		elibc_glibc? (
			https://github.com/Prowlarr/Prowlarr/releases/download/v${PV}/Prowlarr.develop.${PV}.linux-core-arm.tar.gz
		)
		elibc_musl? (
			https://github.com/Prowlarr/Prowlarr/releases/download/v${PV}/Prowlarr.develop.${PV}.linux-musl-core-arm.tar.gz
		)
	)
	arm64? (
		elibc_glibc? (
			https://github.com/Prowlarr/Prowlarr/releases/download/v${PV}/Prowlarr.develop.${PV}.linux-core-arm64.tar.gz
		)
		elibc_musl? (
			https://github.com/Prowlarr/Prowlarr/releases/download/v${PV}/Prowlarr.develop.${PV}.linux-musl-core-arm64.tar.gz
		)
	)
"
S="${WORKDIR}/Prowlarr"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm ~arm64"
RESTRICT="bindist strip test"

RDEPEND="
	acct-group/prowlarr
	acct-user/prowlarr
	dev-libs/icu
	dev-db/sqlite
"

QA_PREBUILT="*"

src_prepare() {
	default

	# https://github.com/dotnet/runtime/issues/57784
	find . -type f -iname libcoreclrtraceptprovider.so -delete || die
}

src_install() {
	newinitd "${FILESDIR}/prowlarr.init" prowlarr

	keepdir /var/lib/prowlarr
	fowners -R prowlarr:prowlarr /var/lib/prowlarr

	insinto /etc/logrotate.d
	insopts -m0644 -o root -g root
	newins "${FILESDIR}/prowlarr.logrotate" prowlarr

	dodir  "/opt/prowlarr"
	cp -R "${S}/." "${D}/opt/prowlarr" || die "Install failed!"

	systemd_dounit "${FILESDIR}/prowlarr.service"
	systemd_newunit "${FILESDIR}/prowlarr.service" "prowlarr@.service"
}
