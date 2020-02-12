# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=JACOBY
DIST_VERSION=1.35
DIST_EXAMPLES=("examples/*" "tutorial")
inherit perl-module

DESCRIPTION="Expect for Perl"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~riscv s390 ~sh sparc x86"
IUSE="test minimal"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-IO
	>=dev-perl/IO-Tty-1.110.0
	!minimal? (
		dev-perl/IO-Stty
	)
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
	test? (
		virtual/perl-File-Temp
		virtual/perl-Test-Simple
	)
"
