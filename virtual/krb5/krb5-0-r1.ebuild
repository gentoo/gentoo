# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-build

DESCRIPTION="Virtual for Kerberos V implementation"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ~ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	|| (
		>=app-crypt/mit-krb5-1.12.1-r1[${MULTILIB_USEDEP}]
		>=app-crypt/heimdal-1.5.3-r2[${MULTILIB_USEDEP}]
	)"
