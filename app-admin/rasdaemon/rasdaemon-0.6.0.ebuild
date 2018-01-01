# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit systemd

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
"

src_configure() {
	econf --enable-mce \
		--enable-aer \
		--enable-sqlite3 \
		--enable-extlog \
		--enable-abrt-report \
		--enable-non-standard \
		--enable-hisi-ns-decode \
		--enable-arm
}

src_install() {
	default
	systemd_dounit misc/*.service
}
