# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Virtual for qmail"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86"

# netqmail-1.05 is a special case, because it's a vanilla
# qmail-1.03 but patched to fix some things.
# See its website, http://www.qmail.org/netqmail/

RDEPEND="|| (
	~mail-mta/netqmail-1.06
	~mail-mta/mini-qmail-1.05
	~mail-mta/mini-qmail-1.06
	~mail-mta/qmail-ldap-${PV}
)"
