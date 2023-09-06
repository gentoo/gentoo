# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Base for all cron ebuilds"
HOMEPAGE="https://wiki.gentoo.org/wiki/Cron"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

DEPEND="acct-group/cron"
RDEPEND="
	${DEPEND}
	acct-user/cron
"

src_install() {
	newsbin "${FILESDIR}"/run-crons-${PV} run-crons

	diropts -m0750
	keepdir /etc/cron.{hourly,daily,weekly,monthly}

	keepdir /var/spool/cron/lastrun
}

pkg_postinst() {
	elog "To add a user to the cron group so it can create cron jobs, run:"
	elog
	elog "    usermod -a -G cron <user>"
	elog
	elog "For more information, visit the wiki page:"
	elog "https://wiki.gentoo.org/wiki/Cron"
}
