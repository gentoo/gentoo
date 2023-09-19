# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ETHER
DIST_VERSION=2.000010
inherit perl-module

DESCRIPTION="Release tests for minimum required versions"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Data-Section-0.4.0
	>=dev-perl/Dist-Zilla-4.0.0
	dev-perl/Moose
	virtual/perl-Scalar-List-Utils
	dev-perl/Sub-Exporter-ForMethods
	dev-perl/Test-MinimumVersion
	dev-perl/namespace-autoclean
"
DEPEND="
	dev-perl/Module-Build-Tiny
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.34.0
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-Module-Metadata
		virtual/perl-IO
		dev-perl/Test-Output
		>=virtual/perl-Test-Simple-0.960.0
	)
"
