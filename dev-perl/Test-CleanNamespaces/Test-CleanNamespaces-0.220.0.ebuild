# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ETHER
DIST_VERSION=0.22
inherit perl-module

DESCRIPTION="Check for uncleaned imports"

SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ppc ppc64 ~sparc x86"
IUSE="test minimal"

# r:Test::Builder -> Test-Simple
# t:Scalar::Util -> Scalar-List-Utils
# t:Test::Tester -> ( Ugh )
RDEPEND="
	!minimal? (
		dev-perl/Package-Stash-XS
	)
	>=virtual/perl-Exporter-5.570.0
	virtual/perl-File-Spec
	dev-perl/Module-Runtime
	>=dev-perl/Package-Stash-0.140.0
	dev-perl/Sub-Identify
	virtual/perl-Test-Simple
"
DEPEND="${RDEPEND}
	>=virtual/perl-CPAN-Meta-Requirements-2.120.620
	virtual/perl-ExtUtils-MakeMaker
	!<dev-perl/Role-Tiny-1.3.0
	test? (
		!minimal? (
			>=virtual/perl-CPAN-Meta-2.120.900
		)
		dev-perl/File-pushd
		virtual/perl-Scalar-List-Utils
		dev-perl/Sub-Exporter
		dev-perl/Test-Deep
		dev-perl/Test-Needs
		>=virtual/perl-Test-Simple-1.1.10
		>=dev-perl/Test-Warnings-0.9.0
		virtual/perl-if
		dev-perl/namespace-clean
		virtual/perl-parent
	)
"
