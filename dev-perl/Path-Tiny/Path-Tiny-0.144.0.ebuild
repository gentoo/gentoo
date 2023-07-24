# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DAGOLDEN
DIST_VERSION=0.144
inherit perl-module

DESCRIPTION="File path utility"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="minimal"

RDEPEND="
	!minimal? (
		>=dev-perl/Unicode-UTF8-0.580.0
	)
	virtual/perl-Carp
	>=virtual/perl-Digest-1.30.0
	>=virtual/perl-Digest-SHA-5.450.0
	virtual/perl-Encode
	>=virtual/perl-Exporter-5.570.0
	>=virtual/perl-File-Path-2.70.0
	>=virtual/perl-File-Spec-0.860.0
	>=virtual/perl-File-Temp-0.190.0
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	test? (
		!minimal? (
			>=virtual/perl-JSON-PP-2.273.0
			dev-perl/Test-FailWarnings
			dev-perl/Test-MockRandom
		)
		>=virtual/perl-Test-Simple-0.960.0
	)
"
