# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic linux-info systemd

DESCRIPTION="Reliability, Availability and Serviceability logging tool"
HOMEPAGE="http://www.infradead.org/~mchehab/rasdaemon/"
SRC_URI="http://www.infradead.org/~mchehab/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="sqlite"

DEPEND=""
RDEPEND="
	${DEPEND}
	sys-devel/gettext
	sys-apps/dmidecode
	sqlite? (
		dev-db/sqlite
		dev-perl/DBD-SQLite
	)
	elibc_musl? ( sys-libs/argp-standalone )
"

PATCHES=(
	"${FILESDIR}/sysconfig-fix-0.6.7.patch"
	"${FILESDIR}"/${P}-musl.patch
)

pkg_setup() {
	linux-info_pkg_setup
	local CONFIG_CHECK="~ACPI_EXTLOG"
	check_extra_config
}

src_prepare() {
	default

	# avoid re-configure due to automake trigger
	eautoreconf
}

src_configure() {
	local myconf=(
		$(use_enable sqlite sqlite3)
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

	use elibc_musl && append-libs argp

	econf "${myconf[@]}"
}

src_install() {
	default

	keepdir "/var/lib/${PN}"

	systemd_dounit misc/*.service

	newinitd "${FILESDIR}/rasdaemon.openrc-r2" rasdaemon
	newinitd "${FILESDIR}/ras-mc-ctl.openrc-r1" ras-mc-ctl
	newconfd "${FILESDIR}"/rasdaemon.confd rasdaemon
}
