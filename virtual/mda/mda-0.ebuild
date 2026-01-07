# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual for Message Delivery Agents"

SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~m68k ~mips ppc ppc64 ~s390 ~sparc x86"

# mail-mta/citadel is from sunrise
RDEPEND="
	|| (
		mail-filter/procmail
		mail-filter/maildrop
		mail-mta/postfix
		mail-mta/courier
		mail-mta/mini-qmail
		mail-mta/netqmail
		mail-mta/qmail-ldap
		mail-mta/citadel
	)
"
