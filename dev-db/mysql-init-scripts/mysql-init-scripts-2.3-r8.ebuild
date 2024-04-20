# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd s6 tmpfiles

DESCRIPTION="Gentoo MySQL init scripts"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
# Need to set S due to PMS saying we need it existing, but no SRC_URI
S=${WORKDIR}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

# This _will_ break with MySQL 5.0, 4.x, 3.x
# It also NEEDS openrc for the save_options/get_options builtins.
# The s6 support was added after openrc 0.16.2
# mysql-connector-c needed for my_print_defaults
RDEPEND="
	!<dev-db/mysql-5.1
	!<sys-apps/openrc-0.16.2
	dev-db/mysql-connector-c
	!prefix? (
		acct-group/mysql acct-user/mysql
	)
"

src_install() {
	newconfd "${FILESDIR}"/conf.d-2.0 mysql

	# s6 init scripts
	if use amd64 || use x86 ; then
		newconfd "${FILESDIR}"/conf.d-2.0 mysql-s6
		newinitd "${FILESDIR}"/init.d-s6-2.3 mysql-s6
		s6_install_service mysql "${FILESDIR}"/run-s6
		s6_install_service mysql/log "${FILESDIR}"/log-s6
	fi

	newinitd "${FILESDIR}"/init.d-2.3 mysql
	newinitd "${FILESDIR}"/init.d-supervise-2.3 mysql-supervise

	# systemd unit installation
	exeinto /usr/libexec
	doexe "${FILESDIR}"/mysqld-wait-ready
	systemd_newunit "${FILESDIR}"/mysqld-v2.service mysqld.service
	systemd_newunit "${FILESDIR}"/mysqld_at-v2.service mysqld@.service
	newtmpfiles "${FILESDIR}"/mysql.conf-r1 mysql.conf

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/logrotate.mysql-2.3 mysql
}

pkg_postinst() {
	tmpfiles_process mysql.conf

	if use amd64 || use x86 ; then
		elog "To use the mysql-s6 script, you need to install the optional sys-apps/s6 package."
		elog "If you wish to use s6 logging support, comment out the log-error setting in your my.cnf"
		elog
	fi

	elog "Starting with version 10.1.8, MariaDB includes an improved systemd unit named mariadb.service"
	elog "You should prefer that unit over this package's mysqld.service."
}
