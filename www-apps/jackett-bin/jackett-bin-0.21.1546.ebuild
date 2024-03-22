# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="API Support for your favorite torrent trackers"
HOMEPAGE="https://github.com/Jackett/Jackett/"

SRC_URI="
	amd64? (
		elibc_glibc? (
			https://github.com/Jackett/Jackett/releases/download/v${PV}/Jackett.Binaries.LinuxAMDx64.tar.gz
				-> jackett-${PV}-x64.tar.gz
		)
		elibc_musl? (
			https://github.com/Jackett/Jackett/releases/download/v${PV}/Jackett.Binaries.LinuxMuslAMDx64.tar.gz
				-> jackett-${PV}-musl-x64.tar.gz
		)
	)
	arm? (
		elibc_glibc? (
			https://github.com/Jackett/Jackett/releases/download/v${PV}/Jackett.Binaries.LinuxARM32.tar.gz
				-> jackett-${PV}-arm.tar.gz
		)
		elibc_musl? (
			https://github.com/Jackett/Jackett/releases/download/v${PV}/Jackett.Binaries.LinuxMuslARM32.tar.gz
				-> jackett-${PV}-musl-arm.tar.gz
		)
	)
	arm64? (
		elibc_glibc? (
			https://github.com/Jackett/Jackett/releases/download/v${PV}/Jackett.Binaries.LinuxARM64.tar.gz
				-> jackett-${PV}-arm64.tar.gz
		)
		elibc_musl? (
			https://github.com/Jackett/Jackett/releases/download/v${PV}/Jackett.Binaries.LinuxMuslARM64.tar.gz
				-> jackett-${PV}-musl-arm64.tar.gz
		)
	)
"
S="${WORKDIR}/Jackett"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="bindist strip test"

RDEPEND="
	acct-group/jackett
	acct-user/jackett
	media-video/mediainfo
	dev-libs/icu
	dev-util/lttng-ust:0
	dev-db/sqlite
"

QA_PREBUILT="*"

src_prepare() {
	default

	# https://github.com/dotnet/runtime/issues/57784
	rm libcoreclrtraceptprovider.so || die
}

src_install() {
	newinitd "${FILESDIR}/jackett.init" jackett

	keepdir /var/lib/jackett
	fowners -R jackett:jackett /var/lib/jackett

	insinto /etc/logrotate.d
	insopts -m0644 -o root -g root
	newins "${FILESDIR}/jackett.logrotate" jackett

	dodir  "/opt/jackett"
	cp -R "${S}/." "${D}/opt/jackett" || die "Install failed!"

	systemd_dounit "${FILESDIR}/jackett.service"
	systemd_newunit "${FILESDIR}/jackett.service" "jackett@.service"
}
