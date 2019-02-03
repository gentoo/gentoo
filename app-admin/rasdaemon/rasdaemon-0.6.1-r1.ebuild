# Copyright 1999-2018 Gentoo Foundation
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
	local CONFIG_CHECK="~FUNCTION_TRACER ~FUNCTION_GRAPH_TRACER ~STACK_TRACER ~DYNAMIC_FTRACE"
	check_extra_config
}

src_configure() {
	econf --enable-abrt-report \
		--enable-aer \
		--enable-arm \
		--enable-extlog \
		--enable-hisi-ns-decode \
		--enable-mce \
		--enable-non-standard \
		--enable-sqlite3 \
		--localstatedir=/var
}

src_install() {
	default
	systemd_dounit misc/*.service
}
