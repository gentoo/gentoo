# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils webapp eutils depend.apache

WAS_VER="0.1.2b"

DESCRIPTION="Utility for monitoring and archiving AOL Instant Messenger messages across a network"
HOMEPAGE="http://sourceforge.net/projects/aimsniff/"
SRC_URI="
	mirror://sourceforge/${PN}/${P}.tar.gz
	http? ( mirror://sourceforge/${PN}/was-${WAS_VER}.tar.gz )
"

LICENSE="GPL-2"
KEYWORDS="~amd64 ppc x86"
#SLOT empty due to webapp
IUSE="samba mysql http"

RDEPEND="
	dev-lang/perl[gdbm]
	dev-perl/Net-Pcap
	dev-perl/NetPacket
	dev-perl/Unicode-String
	dev-perl/Proc-Daemon
	dev-perl/Proc-Simple
	dev-perl/DBI
	dev-perl/Unix-Syslog
	mysql? ( virtual/mysql dev-perl/DBD-mysql )
	samba? ( net-fs/samba )
"

want_apache2 http

pkg_setup() {
	depend.apache_pkg_setup http

	use http && webapp_pkg_setup
}

src_install() {
	use http && webapp_src_preinst

	newsbin aimSniff.pl aimsniff
	insinto /etc/${PN}
	doins aimsniff.config
	insinto /usr/share/doc/${PF}
	doins table.struct
	dodoc README ChangeLog

	if use http; then
		cp ../was-${WAS_VER}/docs/README README.WAS
		dodoc README.WAS

		rm -rf ../was-${WAS_VER}/docs
		mv ../was-${WAS_VER}/ "${D}"${MY_HTDOCSDIR}/was

		webapp_serverowned ${MY_HTDOCSDIR}/was

		# This file needs to be serverowned as the server won't be able to write to it if it were
		# webapp_configfile'ed.
		webapp_serverowned ${MY_HTDOCSDIR}/was/.config.php

		webapp_src_install
	fi

	newinitd "${FILESDIR}"/aimsniff.rc aimsniff
}

pkg_postinst() {
	if use mysql
	then
		echo
		elog "To create and enable the mysql database, please run: "
		elog "emerge --config =${PF}"

		if use http; then
			echo "To create and enable the mysql database, please run:
			emerge --config =${PF}" > apache-postinst
			webapp_postinst_txt en apache-postinst
		fi
	fi

	if use http; then
		elog
		elog "Go to http://${HOSTNAME}/was/admin.php to configure WAS."

		echo "Go to http://${HOSTNAME}/was/admin.php to configure WAS." > was-postinst
		webapp_postinst_txt en was-postinst
	fi
}

pkg_config() {
	echo
	einfo "Creating mysql database aimsniff using /usr/share/doc/${PF}/table.struct:"
	echo -n "Please enter your mysql root password: "
	read mysql_root
	/usr/bin/mysqladmin -p$mysql_root -u root create aimsniff
	/usr/bin/mysql -p$mysql_root -u root aimsniff < /usr/share/doc/${PF}/table.struct
	echo -n "Please enter your username that you want to connect to the database with: "
	read user
	echo -n "Please enter the password that you want to use for your database: "
	read password
	einfo "Granting permisions on database using 'GRANT ALL ON aimsniff.* TO $user IDENTIFIED BY '$password';'"
	echo "GRANT ALL ON aimsniff.* TO $user@localhost IDENTIFIED BY '$password';" | /usr/bin/mysql -p$mysql_root -u root aimsniff
	echo
}
