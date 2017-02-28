# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=ETHER
MODULE_VERSION=0.18
inherit perl-module

DESCRIPTION="Check for uncleaned imports"

SLOT="0"
KEYWORDS="amd64 ~arm hppa ~ppc ~ppc64 ~x86"
IUSE="test minimal"

# r:Test::Builder -> Test-Simple
# t:Scalar::Util -> Scalar-List-Utils
# t:Test::Tester -> ( Ugh )
RDEPEND="
	!minimal? (
		dev-perl/Package-Stash-XS
	)
	dev-perl/File-Find-Rule
	dev-perl/File-Find-Rule-Perl
	virtual/perl-File-Spec
	dev-perl/Module-Runtime
	>=dev-perl/Package-Stash-0.140.0
	dev-perl/Sub-Exporter
	dev-perl/Sub-Identify
	virtual/perl-Test-Simple
	dev-perl/namespace-clean
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	!<dev-perl/Role-Tiny-1.3.0
	test? (
		!minimal? (
			>=virtual/perl-CPAN-Meta-2.120.900
		)
		virtual/perl-Exporter
		virtual/perl-Scalar-List-Utils
		dev-perl/Test-Deep
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/Test-Requires
		>=dev-perl/Test-Warnings-0.9.0
		virtual/perl-if
		virtual/perl-parent
	)
"

SRC_TEST="do parallel"

src_test() {
	# Bug 584238 Avoidance
	if perl -e 'exit ( eval { require Test::Tester; 1 } ? 0 : 1 )'; then
		perl-module_src_test
	else
		einfo "Test phase skipped: Test::Tester required for tests"
		einfo "Please upgrade to >=dev-lang/perl-5.22.0 or >=virtual/perl-Test-Simple-1.1.10"
		einfo "if you want this tested"
	fi
}
