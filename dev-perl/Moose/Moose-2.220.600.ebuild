# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=2.2206
DIST_EXAMPLES=("benchmarks/*")

inherit perl-module

DESCRIPTION="Postmodern object system for Perl 5"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

RDEPEND="
	>=virtual/perl-Carp-1.220.0
	>=dev-perl/Class-Load-0.90.0
	>=dev-perl/Class-Load-XS-0.10.0
	>=dev-perl/Data-OptList-0.110.0
	dev-perl/Devel-GlobalDestruction
	>=dev-perl/Devel-OverloadInfo-0.5.0
	>=dev-perl/Devel-StackTrace-2.30.0
	>=dev-perl/Dist-CheckConflicts-0.20.0
	>=dev-perl/Eval-Closure-0.40.0
	>=virtual/perl-Scalar-List-Utils-1.560.0
	>=dev-perl/MRO-Compat-0.50.0
	>=dev-perl/Module-Runtime-0.14.0
	>=dev-perl/Module-Runtime-Conflicts-0.2.0
	>=dev-perl/Package-DeprecationManager-0.110.0
	>=dev-perl/Package-Stash-0.320.0
	>=dev-perl/Package-Stash-XS-0.240.0
	>=dev-perl/Params-Util-1.0.0
	>=dev-perl/Sub-Exporter-0.980.0
	>=dev-perl/Try-Tiny-0.170.0
	>=virtual/perl-parent-0.223.0
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=virtual/perl-JSON-PP-2.273.0
	test? (
		>=dev-perl/CPAN-Meta-Check-0.11.0
		virtual/perl-CPAN-Meta-Requirements
		virtual/perl-File-Spec
		virtual/perl-Module-Metadata
		>=dev-perl/Test-CleanNamespaces-0.130.0
		>=dev-perl/Test-Fatal-0.1.0
		>=virtual/perl-Test-Simple-0.960.0
		>=dev-perl/Test-Needs-0.2.10
	)
"
