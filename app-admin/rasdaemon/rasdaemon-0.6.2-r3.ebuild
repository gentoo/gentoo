# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-info systemd

DESCRIPTION="Reliability, Availability and Serviceability logging tool"
HOMEPAGE="http://www.infradead.org/~mchehab/rasdaemon/"
SRC_URI="http://www.infradead.org/~mchehab/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	${DEPEND}
	sys-devel/gettext
	dev-db/sqlite
	sys-apps/dmidecode
	dev-perl/DBD-SQLite
"

pkg_setup() {
	linux-info_pkg_setup
	local CONFIG_CHECK="~ACPI_EXTLOG ~DYNAMIC_FTRACE ~FUNCTION_GRAPH_TRACER  ~FUNCTION_TRACER ~STACK_TRACER"
	check_extra_config
}

src_configure() {
	local myconf=(
		--enable-abrt-report
		--enable-aer
		--enable-arm
		--enable-extlog
		--enable-hisi-ns-decode
		--enable-mce
		--enable-non-standard
		--enable-sqlite3
		--includedir="/usr/include/${PN}"
		--localstatedir=/var
	)
	econf "${myconf[@]}"
}

src_install() {
	default

	keepdir "/var/lib/${PN}"

	systemd_dounit misc/*.service

	newinitd "${FILESDIR}/rasdaemon.openrc-r1" rasdaemon
	newinitd "${FILESDIR}/ras-mc-ctl.openrc-r1" ras-mc-ctl
}
