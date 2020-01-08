# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Virtual for Message Delivery Agents"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"

# mail-mta/citadel is from sunrise
RDEPEND="|| (	mail-filter/procmail
				mail-filter/maildrop
				mail-mta/postfix
				mail-mta/courier
				mail-mta/mini-qmail
				mail-mta/netqmail
				mail-mta/qmail-ldap
				mail-mta/citadel )"
