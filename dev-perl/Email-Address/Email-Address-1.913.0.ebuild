# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RJBS
DIST_VERSION=1.913
inherit perl-module

DESCRIPTION="RFC 2822 Address Parsing and Creation"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND=""
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Encode
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.960.0
		virtual/perl-Time-HiRes
	)
"
