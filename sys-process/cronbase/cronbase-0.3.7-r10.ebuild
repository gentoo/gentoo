# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit readme.gentoo-r1

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

DOC_CONTENTS="
	To add a user to the cron group so it can create cron jobs, run:

	    usermod -a -G cron <user>

	For more information, visit the wiki page:
	https://wiki.gentoo.org/wiki/Cron
"

src_install() {
	newsbin "${FILESDIR}"/run-crons-${PV} run-crons

	diropts -m0750
	keepdir /etc/cron.{hourly,daily,weekly,monthly}

	keepdir /var/spool/cron/lastrun
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
