# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MPIOTR
DIST_VERSION=1.7
inherit perl-module

DESCRIPTION="A Perl interface to the iconv() codeset conversion function"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-solaris"

RDEPEND="virtual/libiconv"
DEPEND="${RDEPEND}"
BDEPEND="${RDEPEND}"
