# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/mailx/mailx-1.ebuild,v 1.2 2014/05/13 06:37:03 naota Exp $

EAPI=5

DESCRIPTION="Virtual for mail implementations"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

DEPEND=""
RDEPEND="|| (	net-mail/mailutils
				mail-client/mailx
				mail-client/nail
				sys-freebsd/freebsd-ubin )"
