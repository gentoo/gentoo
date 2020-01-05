# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit cron python-any-r1 toolchain-funcs

DESCRIPTION="A new cron system designed with secure operations in mind by Bruce Guenter"
HOMEPAGE="https://untroubled.org/bcron/"
SRC_URI="https://untroubled.org/bcron/archive/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-libs/bglibs-2.04
	sys-apps/ucspi-unix
	sys-process/cronbase
	virtual/daemontools
	virtual/mta"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}"

CRON_SYSTEM_CRONTAB="yes"

PATCHES=( "${FILESDIR}/${PN}-0.09-fix-socket-permissions.patch" )

src_configure() {
	echo "${ED}/usr/bin" > conf-bin || die
	echo "$(tc-getCC) ${CFLAGS}" > conf-cc || die
	echo "$(tc-getCC) ${CFLAGS} ${LDFLAGS} -L${EPREFIX}/usr/$(get_libdir)/bglibs" > conf-ld || die
	echo "${ED}/usr/share/man" > conf-man || die
}

src_install() {
	default

	docrontab bcrontab
	docrondir -o cron -g cron
	docrondir /var/spool/cron/tmp -o cron -g cron

	keepdir /etc/cron.d
	dodir /etc/bcron
	insinto /etc
	doins "${FILESDIR}"/crontab

	insinto /var/lib/supervise/bcron
	doins bcron-sched.run

	insinto /var/lib/supervise/bcron/log
	doins bcron-sched-log.run

	insinto /var/lib/supervise/bcron-spool
	doins bcron-spool.run

	insinto /var/lib/supervise/bcron-update
	doins bcron-update.run

	doman bcrontab.1 crontab.5 bcron-update.8 bcron-start.8
	doman bcron-spool.8 bcron-sched.8 bcron-exec.8
	dodoc ANNOUNCEMENT NEWS README TODO
}

pkg_config() {
	cd "${EROOT}"/var/lib/supervise/bcron || die
	[[ -e run ]] && ( cp run bcron-sched.run.`date +%Y%m%d%H%M%S` || die )
	cp bcron-sched.run run || die
	chmod u+x run || die

	cd "${EROOT}"/var/lib/supervise/bcron/log || die
	[[ -e run ]] && ( cp run bcron-sched-log.run.`date +%Y%m%d%H%M%S` || die )
	cp bcron-sched-log.run run || die
	chmod u+x run || die

	cd "${EROOT}"/var/lib/supervise/bcron-spool || die
	[[ -e run ]] && ( cp run bcron-spool.run.`date +%Y%m%d%H%M%S` || die )
	cp bcron-spool.run run || die
	chmod u+x run || die

	cd "${EROOT}"/var/lib/supervise/bcron-update || die
	[[ -e run ]] && ( cp run bcron-update.run.`date +%Y%m%d%H%M%S` || die )
	cp bcron-update.run run || die
	chmod u+x run || die

	[[ ! -e "${EROOT}"/var/spool/cron/trigger ]] && ( mkfifo "${EROOT}"/var/spool/cron/trigger || die )
	chown cron:cron "${EROOT}"/var/spool/cron/trigger || die
	chmod go-rwx "${EROOT}"/var/spool/cron/trigger || die
}

pkg_postinst() {
	elog "Run "
	elog "emerge --config '=${CATEGORY}/${PF}'"
	elog "to create or update your run files (backups are created) in"
	elog "		/var/lib/supervise/bcron (bcron daemon) and"
	elog "		/var/lib/supervise/bcron-spool (crontab receiver) and"
	elog "		/var/lib/supervise/bcron-update (system crontab updater)"

	cron_pkg_postinst
}
