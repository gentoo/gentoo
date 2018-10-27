# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DAGOLDEN
DIST_VERSION=1.06
inherit perl-module

DESCRIPTION="Compare the difference between numbers against a given tolerance"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 sparc x86 ~ppc-aix ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

IUSE="test minimal"
RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-Test-Simple
"
DEPEND="
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	test? (
		!minimal? (
			>=virtual/perl-CPAN-Meta-2.120.900
		)
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.960.0
	)
"
