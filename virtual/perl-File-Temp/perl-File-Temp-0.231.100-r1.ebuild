# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for ${PN#perl-}"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

RDEPEND="
	~perl-core/${PN#perl-}-${PV}
	dev-lang/perl:=
"

# this is the dev-lang/perl-5.34 and dev-lang/perl-5.36 and dev-lang/perl-5.38 and dev-lang/perl-5.40 and dev-lang/perl-5.42 version but we want the security patch
