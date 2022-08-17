# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=1.73
inherit perl-module

DESCRIPTION="Read/Write YAML files with as little code as possible"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="minimal"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-Scalar-List-Utils
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		!minimal? (
			>=virtual/perl-CPAN-Meta-2.120.900
			>=dev-perl/JSON-MaybeXS-1.1.0
		)
		>=virtual/perl-File-Spec-0.80.0
		>=virtual/perl-File-Temp-0.190.0
		virtual/perl-Getopt-Long
		virtual/perl-IO
		virtual/perl-JSON-PP
		>=virtual/perl-Test-Simple-0.880.0
	)
"
