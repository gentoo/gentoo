# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Integrated snmptt visualization addon for the Nagios monitoring system"
HOMEPAGE="http://www.nagtrap.org/"
SRC_URI="http://www.nagiosforge.org/gf/download/frsrelease/126/252/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="virtual/httpd-php"
RDEPEND="dev-lang/php[mysql]
		net-analyzer/snmptt
		net-analyzer/nagios-core
		virtual/httpd-php"

src_install() {
	dodoc ChangeLog THANKS

	dodir /usr/share/nagtrap
	cp -r {db,nagtrap} "${D}"/usr/share/nagtrap/
	fperms 640 "${D}"/usr/share/nagtrap/nagtrap/etc/config.ini.php-dist

	sed -i -e 's#use lib.*#use lib "/usr/lib/nagios/plugins";#g' \
		plugin/check_snmptraps.pl || die "sed failed"

	insinto /usr/$(get_libdir)/nagios/plugins
	insopts -m 750 -g nagios
	doins plugin/check_snmptraps.pl
}

pkg_postinst() {
	elog "Before running NagTrap for the first time, you will need setup its configuration"
	elog "/usr/share/nagtrap/nagtrap/etc/config.ini.php"
	elog "A sample is installed in"
	elog "/usr/share/nagtrap/nagtrap/etc/config.ini.php-sample"
	elog
	elog "NagTrap requires snmptt to write traps into a MySQL database."
	elog "A database schema is available in {$D}usr/share/nagtrap/db"
}
