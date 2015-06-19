# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/daemontools/daemontools-0.ebuild,v 1.3 2011/07/11 15:27:50 aballier Exp $

DESCRIPTION="Virtual for daemontools"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"

IUSE=""
DEPEND=""

RDEPEND="|| (
	sys-process/daemontools
	sys-process/daemontools-encore
)"
