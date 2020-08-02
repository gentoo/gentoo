# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd

DESCRIPTION="A server software for hosting quality voice communication via the internet"
HOMEPAGE="https://www.teamspeak.com/"
SRC_URI="
	amd64? ( https://files.teamspeak-services.com/releases/server/${PV}/teamspeak3-server_linux_amd64-${PV}.tar.bz2 )
	x86? ( https://files.teamspeak-services.com/releases/server/${PV}/teamspeak3-server_linux_x86-${PV}.tar.bz2 )
"

LICENSE="Apache-2.0 Boost-1.0 BSD LGPL-2.1 LGPL-3 MIT teamspeak3"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="doc mysql tsdns"

RESTRICT="bindist mirror"

RDEPEND="
	acct-group/teamspeak
	acct-user/teamspeak
"

QA_PREBUILT="
	opt/teamspeak3-server/libmariadb.so.2
	opt/teamspeak3-server/libts3db_mariadb.so
	opt/teamspeak3-server/libts3db_sqlite3.so
	opt/teamspeak3-server/libts3_ssh.so
	opt/teamspeak3-server/ts3server
	opt/teamspeak3-server/tsdnsserver
"

src_unpack() {
	default

	mv teamspeak3-server_linux_$(usex amd64 amd64 x86) "${P}" || die
}

src_install() {
	diropts -o teamspeak -g teamspeak
	keepdir /opt/teamspeak3-server /var/log/teamspeak3-server

	diropts
	keepdir /etc/teamspeak3-server

	touch "${ED}"/opt/teamspeak3-server/.ts3server_license_accepted || die

	exeinto /opt/teamspeak3-server
	doexe ts3server

	dodir /opt/bin
	dosym ../teamspeak3-server/ts3server /opt/bin/ts3server

	exeinto /opt/teamspeak3-server
	doexe libts3db_sqlite3.so libts3_ssh.so

	insinto /opt/teamspeak3-server/serverquerydocs
	doins -r serverquerydocs/.

	insinto /opt/teamspeak3-server/sql
	doins sql/*.sql
	doins -r sql/create_sqlite

	insinto /etc/teamspeak3-server
	newins "${FILESDIR}"/ts3server.ini-r1 ts3server.ini

	dodoc CHANGELOG
	docinto ts3server
	dodoc doc/*.txt

	newinitd "${FILESDIR}"/teamspeak.initd-r1 teamspeak3-server
	systemd_newunit "${FILESDIR}"/teamspeak.service teamspeak3-server.service

	newenvd - 99teamspeak3-server <<- EOF
		CONFIG_PROTECT="/etc/teamspeak3-server/ts3server.ini /etc/teamspeak3-server/ts3server_mariadb.ini /etc/teamspeak3-server/tsdns_settings.ini"
	EOF

	if use doc; then
		docinto html
		dodoc -r doc/serverquery/.
	fi

	if use mysql; then
		insinto /etc/teamspeak3-server
		newins "${FILESDIR}"/ts3server_mariadb.ini.sample-r1 ts3server_mariadb.ini.sample
		doins "${FILESDIR}"/ts3db_mariadb.ini.sample

		exeinto /opt/teamspeak3-server
		doexe libts3db_mariadb.so
		doexe redist/libmariadb.so.2

		insinto /opt/teamspeak3-server/sql
		doins -r sql/create_mariadb
		doins -r sql/updates_and_fixes
	fi

	if use tsdns; then
		exeinto /opt/teamspeak3-server
		doexe tsdns/tsdnsserver
		dodir /opt/bin
		dosym ../teamspeak3-server/tsdnsserver /opt/bin/tsdnsserver

		insinto /etc/teamspeak3-server
		doins tsdns/tsdns_settings.ini.sample

		docinto tsdns
		dodoc tsdns/{README,USAGE}
	fi
}

pkg_postinst() {
	elog "If you have a license,"
	elog "put it in /opt/teamspeak3-server named as licensekey.dat."
	elog "Please note, that the license must be writeable by the teamspeak user,"
	elog "as it will be automatically updated every six months."
}
