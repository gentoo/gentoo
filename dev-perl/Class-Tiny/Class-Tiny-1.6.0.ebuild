# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DAGOLDEN
DIST_VERSION=1.006
inherit perl-module

DESCRIPTION="Minimalist class construction"

SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ppc ~ppc64 ~riscv ~s390 ~sh ~sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
LICENSE="Apache-2.0"
IUSE="test minimal"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
"
DEPEND="${RDEPEND}
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
