# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/cron/cron-0.ebuild,v 1.1 2011/04/20 17:46:54 ulm Exp $

DESCRIPTION="Virtual for cron"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND="|| ( sys-process/vixie-cron
		sys-process/bcron
		sys-process/cronie
		sys-process/dcron
		sys-process/fcron )"
