# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/syslogread/syslogread-0.92-r1.ebuild,v 1.1 2014/08/18 20:07:14 creffett Exp $

EAPI=5

inherit eutils toolchain-funcs multilib user

DESCRIPTION="Syslog message handling tools"
HOMEPAGE="http://untroubled.org/syslogread/"
SRC_URI="http://untroubled.org/syslogread/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND=">=dev-libs/bglibs-1.106"
RDEPEND="virtual/daemontools"

pkg_setup() {
	enewgroup syslog
	enewuser syslog -1 -1 /nonexistent syslog
}

src_prepare() {
	epatch "${FILESDIR}"/syslogread-0.92-fix-parallel-build.patch
}

src_configure() {
	echo "/usr/include/bglibs/" > conf-bgincs
	echo "/usr/$(get_libdir)/bglibs/" > conf-bglibs
	echo "${D}/usr/bin" > conf-bin
	echo "${D}/usr/share/man" > conf-man
	echo "$(tc-getCC) ${CFLAGS}" > conf-cc
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld
}

src_install() {
	dodir /usr/bin
	dodir /usr/share/man
	./installer || die

	dodoc ANNOUNCEMENT ChangeLog README

	insinto /var/lib/supervise/klogd
	newins "${FILESDIR}/${PV}/klogd.run" klogd.run

	insinto /var/lib/supervise/syslogd
	newins "${FILESDIR}/${PV}/syslogread.run" syslogread.run

	insinto /var/lib/supervise/syslogd/log
	newins "${FILESDIR}/${PV}/syslogread-log.run" syslogread-log.run

	# See ChangeLog for why these are commented out:

	#newinitd "${FILESDIR}/${PV}/syslogread.init" syslogread

	#keepdir /var/log/klogd
	#keepdir /var/log/syslog

	#fowners syslog:syslog /var/log/syslog
	#fperms o-rwx /var/log/syslog
}

pkg_postinst() {
	echo
	elog "Run "
	elog "emerge --config =${PF}"
	elog "to create or update your run files (backups are created) in"
	elog "    /var/lib/supervise/klogd (kernel logger)"
	elog "    /var/lib/supervise/syslog (system logger)"
	echo
}

pkg_config() {
	cd "${ROOT}"var/lib/supervise/klogd
	[ -e run ] && cp run klogd.run.`date +%Y%m%d%H%M%S`
	cp klogd.run run
	chmod u+x run

	cd "${ROOT}"var/lib/supervise/syslogd
	[ -e run ] && cp run syslogread.run.`date +%Y%m%d%H%M%S`
	cp syslogread.run run
	chmod u+x run

	cd "${ROOT}"var/lib/supervise/syslogd/log
	[ -e run ] && cp run syslogread-log.run.`date +%Y%m%d%H%M%S`
	cp syslogread-log.run run
	chmod u+x run
}
