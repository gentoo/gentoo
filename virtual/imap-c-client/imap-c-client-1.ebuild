# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/imap-c-client/imap-c-client-1.ebuild,v 1.3 2012/05/29 17:10:28 aballier Exp $

EAPI=3

DESCRIPTION="Virtual for IMAP c-client"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="ssl"

DEPEND=""
RDEPEND=" || (	net-libs/c-client[ssl=]
				net-mail/uw-imap[ssl=] )"
