# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Tango is an Open Source solution for SCADA and DCS"
HOMEPAGE="https://www.tango-controls.org/"
SRC_URI="mirror://sourceforge/tango-cs/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+dbserver java +mariadb +zeromq"

DEPEND="
	net-misc/omniORB
	mariadb? ( dev-db/mariadb-connector-c )
	!mariadb? ( dev-db/mysql-connector-c )
	dbserver? (
		mariadb? ( dev-db/mariadb[server] )
		!mariadb? ( dev-db/mysql[server] )
		virtual/mysql[server] )
	java? ( virtual/jdk:* )
	zeromq? ( net-libs/zeromq )
"
RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}"

src_configure() {
	local MYCONF
	if use mariadb; then
		MYCONF+=(
			$(use_enable mariadb)
			--with-mariadbclient-include="${EPREFIX}/usr/include/mysql"
		)
	fi

	econf \
		--with-omni="${EPREFIX}/usr" \
		$(use_enable zeromq zmq) \
		$(use_enable java) \
		$(use_enable dbserver) \
		${MYCONF[@]}
}
