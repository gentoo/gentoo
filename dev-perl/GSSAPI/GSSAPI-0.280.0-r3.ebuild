# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=AGROLMS
DIST_VERSION=0.28
inherit perl-module

DESCRIPTION="Perl extension providing access to the GSSAPIv2 library"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ~ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	virtual/krb5
"
BDEPEND="${RDEPEND}
"
DEPEND="${RDEPEND}
"
