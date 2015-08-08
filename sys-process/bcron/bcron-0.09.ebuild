# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

CRON_SYSTEM_CRONTAB="yes"

inherit cron eutils toolchain-funcs
DESCRIPTION="A new cron system designed with secure operations in mind by Bruce Guenter"

HOMEPAGE="http://untroubled.org/bcron/"
SRC_URI="http://untroubled.org/bcron/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=dev-libs/bglibs-1.031"
RDEPEND=">=sys-process/cronbase-0.3.2
	virtual/mta
	sys-apps/ucspi-unix
	virtual/daemontools"

src_compile() {
	echo "/usr/include/bglibs" > conf-bgincs
	echo "/usr/lib/bglibs" > conf-bglibs
	echo "${D}/usr/bin" > conf-bin
	echo "$(tc-getCC) ${CFLAGS}" > conf-cc
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld
	# bug #278459
	emake -j1 || die "make failed"
}

src_install() {
	einstall || die

	#fix permissions of crontab
	fperms o-rwx /usr/bin/bcrontab
	fowners root:cron /usr/bin/bcrontab

	doman bcrontab.1 crontab.5 bcron-update.8 bcron-start.8
	doman bcron-spool.8 bcron-sched.8 bcron-exec.8

	dodoc ANNOUNCEMENT NEWS README TODO

	keepdir /etc/cron.d

	keepdir /var/spool/cron/crontabs
	keepdir /var/spool/cron/tmp

	for i in crontabs tmp;
	do
		fowners cron:cron /var/spool/cron/$i
		fperms go-rwx /var/spool/cron/$i
	done

	dodir /etc/bcron

	insinto /etc
	doins  "${FILESDIR}"/crontab

	insinto /var/lib/supervise/bcron
	doins bcron-sched.run

	insinto /var/lib/supervise/bcron/log
	doins bcron-sched-log.run

	insinto /var/lib/supervise/bcron-spool
	doins bcron-spool.run

	insinto /var/lib/supervise/bcron-update
	doins bcron-update.run
}

pkg_config() {
	cd "${ROOT}"var/lib/supervise/bcron
	[ -e run ] && cp run bcron-sched.run.`date +%Y%m%d%H%M%S`
	cp bcron-sched.run run
	chmod u+x run

	cd "${ROOT}"/var/lib/supervise/bcron/log
	[ -e run ] && cp run bcron-sched-log.run.`date +%Y%m%d%H%M%S`
	cp bcron-sched-log.run run
	chmod u+x run

	cd "${ROOT}"/var/lib/supervise/bcron-spool
	[ -e run ] && cp run bcron-spool.run.`date +%Y%m%d%H%M%S`
	cp bcron-spool.run run
	chmod u+x run

	cd "${ROOT}"/var/lib/supervise/bcron-update
	[ -e run ] && cp run bcron-update.run.`date +%Y%m%d%H%M%S`
	cp bcron-update.run run
	chmod u+x run

	[ ! -e "${ROOT}"/var/spool/cron/trigger ] && mkfifo "${ROOT}"var/spool/cron/trigger
	chown cron:cron /var/spool/cron/trigger
	chmod go-rwx /var/spool/cron/trigger
}

pkg_postinst() {
	echo
	elog "Run "
	elog "emerge --config =${PF}"
	elog "to create or update your run files (backups are created) in"
	elog "		/var/lib/supervise/bcron (bcron daemon) and"
	elog "		/var/lib/supervise/bcron-spool (crontab receiver) and"
	elog "		/var/lib/supervise/bcron-update (system crontab updater)"

	cron_pkg_postinst
}
