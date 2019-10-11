# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit user

DESCRIPTION="base for all cron ebuilds"
HOMEPAGE="https://www.gentoo.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86"
IUSE=""

S=${WORKDIR}

pkg_setup() {
	enewgroup cron 16
	enewuser cron 16 -1 /var/spool/cron cron
}

src_install() {
	newsbin "${FILESDIR}"/run-crons-${PV} run-crons

	diropts -m0750
	keepdir /etc/cron.{hourly,daily,weekly,monthly}

	keepdir /var/spool/cron/lastrun
	diropts -m0750 -o root -g cron
	keepdir /var/spool/cron
}
