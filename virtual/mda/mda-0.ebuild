# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual for Message Delivery Agents"

SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~sparc64-solaris ~x86-solaris"

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
