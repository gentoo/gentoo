# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RJBS
DIST_VERSION=1.000
inherit perl-module

DESCRIPTION="A role for classes that can be thrown"

SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Devel-StackTrace-1.320.0
	>=dev-perl/Module-Runtime-0.2.0
	>=dev-perl/Moo-1.0.1
	virtual/perl-Scalar-List-Utils
	dev-perl/Sub-Quote
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.960.0
	)
"
