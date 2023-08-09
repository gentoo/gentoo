# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

SRC_URI="https://download.sonarr.tv/v3/main/${PV}/Sonarr.main.${PV}.linux.tar.gz"

DESCRIPTION="Sonarr is a Smart PVR for newsgroup and bittorrent users"
HOMEPAGE="https://www.sonarr.tv"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="bindist strip test"

RDEPEND="
	acct-group/sonarr
	acct-user/sonarr
	>=dev-lang/mono-6.6.0.161
	media-video/mediainfo
	dev-db/sqlite"

QA_PREBUILT="*"

S="${WORKDIR}/Sonarr"

src_install() {
	newinitd "${FILESDIR}/${PN}.init-r2" ${PN}

	keepdir /var/lib/${PN}
	fowners -R ${PN}:${PN} /var/lib/${PN}

	insinto /etc/logrotate.d
	insopts -m0644 -o root -g root
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	dodir  "/opt/${PN}"
	cp -R "${S}/." "${D}/opt/${PN}" || die "Install failed!"

	exeinto "/opt/${PN}"
	doexe "${FILESDIR}/Sonarr"

	systemd_newunit "${FILESDIR}/${PN}.service-r1" "${PN}.service"
	systemd_newunit "${FILESDIR}/${PN}.service-r1" "${PN}@.service"
}
