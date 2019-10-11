# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit multilib-build

DESCRIPTION="Virtual for Kerberos V implementation"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 ~sh sparc x86"

RDEPEND="
	|| (
		>=app-crypt/mit-krb5-1.12.1-r1[${MULTILIB_USEDEP}]
		>=app-crypt/heimdal-1.5.3-r2[${MULTILIB_USEDEP}]
	)"
