# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/mda/mda-0.ebuild,v 1.5 2011/04/24 06:38:28 eras Exp $

EAPI=3

DESCRIPTION="Virtual for Message Delivery Agents"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=""

# mail-mta/citadel is from sunrise
RDEPEND="|| (	mail-filter/procmail
				mail-filter/maildrop
				mail-mta/postfix
				mail-mta/courier
				mail-mta/mini-qmail
				mail-mta/netqmail
				mail-mta/qmail-ldap
				mail-mta/citadel )"
