# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MANU
DIST_VERSION=1.26
inherit perl-module

DESCRIPTION="Perl extension for manipulating IPv4/IPv6 addresses"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

PATCHES=( "${FILESDIR}/initip-0.patch" )
