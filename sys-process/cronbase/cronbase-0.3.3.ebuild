# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit user

DESCRIPTION="base for all cron ebuilds"
HOMEPAGE="https://www.gentoo.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE=""

pkg_setup() {
	enewgroup cron 16
	enewuser cron 16 -1 /var/spool/cron cron
}

src_install() {
	newsbin "${FILESDIR}"/run-crons-${PV} run-crons || die

	diropts -m0750; keepdir /etc/cron.hourly
	diropts -m0750; keepdir /etc/cron.daily
	diropts -m0750; keepdir /etc/cron.weekly
	diropts -m0750; keepdir /etc/cron.monthly

	diropts -m0750 -o root -g cron; keepdir /var/spool/cron

	diropts -m0750; keepdir /var/spool/cron/lastrun
}

pkg_postinst() {
	#Portage doesn't enforce proper permissions on already existing"
	#directories (bug 141619).
	echo
	elog "Forcing proper permissions on"
	elog "${ROOT}etc/cron.{hourly,daily,weekly,monthly},"
	elog "${ROOT}var/spool/cron/ and ${ROOT}var/spool/cron/lastrun/"
	echo
	chmod 0750 "${ROOT}"etc/cron.{hourly,daily,weekly,monthly} \
		|| die "chmod failed"
	chmod 0750 "${ROOT}"var/spool/{cron,cron/lastrun} || die "chmod failed"
	chown root:cron "${ROOT}var/spool/cron" || die "chown failed"
}
