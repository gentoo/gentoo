# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic linux-info systemd

DESCRIPTION="Reliability, Availability and Serviceability logging tool"
HOMEPAGE="https://github.com/mchehab/rasdaemon"
SRC_URI="https://github.com/mchehab/rasdaemon/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 x86"

DEPEND="
	dev-db/sqlite
	elibc_musl? ( sys-libs/argp-standalone )
"
RDEPEND="
	${DEPEND}
	dev-perl/DBI
	dev-perl/DBD-SQLite
	sys-apps/dmidecode
"
BDEPEND="sys-devel/gettext"

pkg_setup() {
	linux-info_pkg_setup
	local CONFIG_CHECK="~ACPI_EXTLOG ~DEBUG_FS"
	check_extra_config
}

src_configure() {
	local myconfargs=(
		--enable-sqlite3
		--enable-abrt-report
		--enable-aer
		--enable-arm
		--enable-extlog
		--enable-hisi-ns-decode
		--enable-mce
		--enable-non-standard
		--enable-devlink
		--enable-diskerror
		--enable-memory-ce-pfa
		--includedir="/usr/include/${PN}"
		--localstatedir=/var
	)

	use elibc_musl && append-libs -largp

	econf "${myconfargs[@]}"
}

src_install() {
	default

	keepdir "/var/lib/${PN}"

	systemd_dounit misc/*.service

	newinitd "${FILESDIR}/rasdaemon.openrc-r2" rasdaemon
	newinitd "${FILESDIR}/ras-mc-ctl.openrc-r1" ras-mc-ctl
	newconfd "${FILESDIR}"/rasdaemon.confd rasdaemon
}
