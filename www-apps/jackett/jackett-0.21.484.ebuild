# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

SRC_URI="
	amd64? ( https://github.com/Jackett/Jackett/releases/download/v${PV}/Jackett.Binaries.LinuxAMDx64.tar.gz -> "${PV}-amd64.tar.gz" )
	arm? ( https://github.com/Jackett/Jackett/releases/download/v${PV}/Jackett.Binaries.LinuxARM32.tar.gz -> "${PV}-amd.tar.gz" )
	arm64? ( https://github.com/Jackett/Jackett/releases/download/v${PV}/Jackett.Binaries.LinuxARM64.tar.gz -> "${PV}-arm64.tar.gz" )
"

DESCRIPTION="API Support for your favorite torrent trackers"
HOMEPAGE="https://github.com/Jackett/Jackett"

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
	sys-libs/glibc
"

QA_PREBUILT="*"

S="${WORKDIR}/Jackett"

src_prepare() {
	default

	# https://github.com/dotnet/runtime/issues/57784
	rm libcoreclrtraceptprovider.so || die
}

src_install() {
	newinitd "${FILESDIR}/${PN}.init" ${PN}

	keepdir /var/lib/${PN}
	fowners -R ${PN}:${PN} /var/lib/${PN}

	insinto /etc/logrotate.d
	insopts -m0644 -o root -g root
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	dodir  "/opt/${PN}"
	cp -R "${S}/." "${D}/opt/jackett" || die "Install failed!"

	systemd_dounit "${FILESDIR}/jackett.service"
	systemd_newunit "${FILESDIR}/jackett.service" "${PN}@.service"
}
