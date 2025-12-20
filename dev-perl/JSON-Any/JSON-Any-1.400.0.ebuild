# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=1.40
inherit perl-module

DESCRIPTION="Wrapper Class for the various JSON classes (DEPRECATED)"

SLOT="0"
KEYWORDS="~amd64 ~mips ~x86 ~x64-macos"

RDEPEND="
	virtual/perl-Carp
	|| (
		>=dev-perl/JSON-XS-2.3
		virtual/perl-JSON-PP
		dev-perl/JSON
	)
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-CPAN-Meta-Requirements-2.120.620
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Data-Dumper
		virtual/perl-File-Spec
		virtual/perl-Module-Metadata
		virtual/perl-Storable
		dev-perl/Test-Fatal
		dev-perl/Test-Needs
		virtual/perl-Test-Simple
		>=dev-perl/Test-Warnings-0.9.0
		dev-perl/Test-Without-Module
	)
"

PERL_RM_FILES=(
	# With 1.400.0, fails as "Failed test 'trapped a failure because of a non-reference'"
	# https://rt.cpan.org/Public/Bug/Display.html?id=127753
	# https://github.com/karenetheridge/JSON-Any/pull/2
	# bug #807316
	t/04-ENV.t
)
