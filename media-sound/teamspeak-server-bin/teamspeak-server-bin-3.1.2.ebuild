# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils systemd user

DESCRIPTION="TeamSpeak is software for quality voice communication via the Internet"
HOMEPAGE="https://www.teamspeak.com/"
SRC_URI="amd64? ( http://ftp.4players.de/pub/hosted/ts3/releases/${PV}/teamspeak3-server_linux_amd64-${PV}.tar.bz2 )
	x86? ( http://ftp.4players.de/pub/hosted/ts3/releases/${PV}/teamspeak3-server_linux_x86-${PV}.tar.bz2 )"

LICENSE="LGPL-2.1 teamspeak3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc tsdns"
# IUSE="doc mysql tsdns"

# RDEPEND="mysql? ( dev-db/mariadb-connector-c:0=
#		<dev-libs/openssl-1.1:0=
#		sys-libs/zlib )"

RESTRICT="mirror strip"

S="${WORKDIR}/teamspeak3-server_linux"

QA_PREBUILT="opt/teamspeak3-server/libts3db_sqlite3.so
		opt/teamspeak3-server/ts3server"

pkg_setup() {
	enewgroup teamspeak
	enewuser teamspeak -1 -1 /opt/teamspeak3-server teamspeak
}

src_unpack() {
	unpack ${A}

	if use amd64; then
		mv "teamspeak3-server_linux_amd64" "teamspeak3-server_linux" || die
	else
		mv "teamspeak3-server_linux_x86" "teamspeak3-server_linux" || die
	fi
}

src_install() {
	# Accept license
	touch "${T%/}"/.ts3server_license_accepted || die
	insinto "/opt/teamspeak3-server"
	doins "${T}"/.ts3server_license_accepted

	# Install binary and wrapper
	exeinto "/opt/teamspeak3-server"
	doexe "ts3server"
	doexe "${FILESDIR}/ts3server-bin"
	dodir "/opt/bin"
	dosym "../teamspeak3-server/ts3server-bin" "/opt/bin/ts3server"

	# Install libs
	exeinto "/opt/teamspeak3-server"
	doexe "libts3db_sqlite3.so"

	# Install sql
	insinto "/opt/teamspeak3-server/sql"
	doins "sql"/*.sql
	doins -r "sql/create_sqlite"

	# Install config
	insinto "/etc/teamspeak3-server"
	doins "${FILESDIR}/ts3server.ini"

	# Install init script and systemd unit
	newinitd "${FILESDIR}/teamspeak.initd" teamspeak3-server
	systemd_newunit "${FILESDIR}/teamspeak.service" teamspeak3-server.service
	systemd_newtmpfilesd "${FILESDIR}/teamspeak.tmpfiles" teamspeak3-server.conf

	# Install optional mysql
	# if use mysql; then
	#	insinto "/etc/teamspeak3-server"
	#	doins "${FILESDIR}/ts3server_mariadb.ini.sample"
	#	doins "${FILESDIR}/ts3db_mariadb.ini.sample"
	#
	#	exeinto "/opt/teamspeak3-server"
	#	doexe "libts3db_mariadb.so"
	#
	#	insinto "/opt/teamspeak3-server/sql"
	#	doins -r "sql/create_mariadb"
	#	doins -r "sql/updates_and_fixes"
	# fi

	# Install optional docs
	if use doc; then
		local HTML_DOCS=( "doc/serverquery/." )

		docinto "serverquery"
		dodoc "serverquerydocs"/*.txt

		docinto "ts3server"
		dodoc "doc"/*.txt
	fi

	# Install tsdns
	if use tsdns; then
		exeinto "/opt/teamspeak3-server"
		doexe "tsdns/tsdnsserver"
		dodir "/opt/bin"
		dosym "../teamspeak3-server/tsdnsserver" "/opt/bin/tsdnsserver"

		insinto "/etc/teamspeak3-server"
		doins "tsdns/tsdns_settings.ini.sample"

		docinto "tsdns"
		dodoc "tsdns/README" "tsdns/USAGE"
	fi

	# Install docs
	einstalldocs

	# Keep directories
	keepdir "/etc/teamspeak3-server"
	keepdir "/var/log/teamspeak3-server"

	# Protect config
	# if use mysql; then
	#	echo "CONFIG_PROTECT=\"/etc/teamspeak3-server/ts3server.ini /etc/teamspeak3-server/ts3server_mariadb.ini\"" > "${T}"/99teamspeak3-server || die
	# else
	echo "CONFIG_PROTECT=\"/etc/teamspeak3-server/ts3server.ini\"" > "${T}"/99teamspeak3-server || die
	# fi
	doenvd "${T}"/99teamspeak3-server

	# Set permissions
	fowners -R teamspeak:teamspeak "/etc/teamspeak3-server" "/opt/teamspeak3-server" "/var/log/teamspeak3-server"
}

pkg_postinst() {
	elog "If you have a Non-Profit License (NPL),"
	elog "place it in /opt/teamspeak3-server as licensekey.dat."
}
