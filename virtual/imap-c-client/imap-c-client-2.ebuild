# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Virtual for IMAP c-client"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE="kerberos ssl"

RDEPEND=" || (	net-libs/c-client[kerberos=,ssl=]
				net-mail/uw-imap[kerberos=,ssl=] )"
