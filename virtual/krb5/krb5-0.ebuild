# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Virtual for Kerberos V implementation"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

RDEPEND="|| ( app-crypt/mit-krb5 app-crypt/heimdal )"
