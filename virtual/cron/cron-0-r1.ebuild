# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/cron/cron-0-r1.ebuild,v 1.3 2015/08/07 22:34:50 rich0 Exp $

EAPI=4

DESCRIPTION="Virtual for cron"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND="|| ( sys-process/cronie
		sys-process/vixie-cron
		sys-process/bcron
		sys-process/dcron
		sys-process/fcron
		sys-process/systemd-cron )"
