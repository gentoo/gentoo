# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DROLSKY
DIST_VERSION=0.83
inherit perl-module

DESCRIPTION="Create DateTime parser classes and objects"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="minimal test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/DateTime-1.0.0
	>=dev-perl/DateTime-Format-Strptime-1.40.0
	>=dev-perl/Params-Validate-0.720.0
	virtual/perl-Scalar-List-Utils
	virtual/perl-parent
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.960.0
		!minimal? (
			dev-perl/Test-Memory-Cycle
			>=dev-perl/Devel-Cycle-1.70.0
		)
	)
"
PERL_RM_FILES=(
	t/99pod.t
)
