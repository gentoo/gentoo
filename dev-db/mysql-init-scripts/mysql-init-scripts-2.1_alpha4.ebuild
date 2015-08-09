# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit systemd s6

DESCRIPTION="Gentoo MySQL init scripts."
HOMEPAGE="http://www.gentoo.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd"
IUSE=""

DEPEND=""
# This _will_ break with MySQL 5.0, 4.x, 3.x
# It also NEEDS openrc for the save_options/get_options builtins.
# The s6 support was added after openrc 0.16.2
RDEPEND="
	!<dev-db/mysql-5.1
	!<sys-apps/openrc-0.16.2
	"
# Need to set S due to PMS saying we need it existing, but no SRC_URI
S=${WORKDIR}

src_install() {
	newconfd "${FILESDIR}/conf.d-2.0" "mysql"

	# s6 init scripts
	if use amd64 || use x86 ; then
		newconfd "${FILESDIR}/conf.d-2.0" "mysql-s6"
		newinitd "${FILESDIR}/init.d-s6" "mysql-s6"
		s6_install_service mysql "${FILESDIR}/run-s6"
		s6_install_service mysql/log "${FILESDIR}/log-s6"
	fi

	newinitd "${FILESDIR}/init.d-2.0" "mysql"

	# systemd unit installation
	exeinto /usr/libexec
	doexe "${FILESDIR}"/mysqld-wait-ready
	systemd_dounit "${FILESDIR}/mysqld.service"
	systemd_newunit "${FILESDIR}/mysqld_at.service" "mysqld@.service"
	systemd_dotmpfilesd "${FILESDIR}/mysql.conf"

	insinto /etc/logrotate.d
	newins "${FILESDIR}/logrotate.mysql" "mysql"
}

pkg_postinst() {
	if use amd64 || use x86 ; then
		elog "To use the mysql-s6 script, you need to install the optional sys-apps/s6 package."
		elog "If you wish to use s6 logging support, comment out the log-error setting in your my.cnf"
	fi
}
