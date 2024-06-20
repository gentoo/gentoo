# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DAGOLDEN
DIST_VERSION=1.008
inherit perl-module

DESCRIPTION="Minimalist class construction"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
LICENSE="Apache-2.0"
IUSE="test minimal"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	test? (
		!minimal? (
			>=virtual/perl-CPAN-Meta-2.120.900
			dev-perl/Test-FailWarnings
		)
		virtual/perl-Exporter
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.960.0
	)
"
