# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ETHER
DIST_VERSION=0.035
inherit perl-module

DESCRIPTION="Add contributor names from git to your distribution"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
RDEPEND="
	virtual/perl-Data-Dumper
	>=dev-perl/Dist-Zilla-4.300.39
	>=dev-perl/Git-Wrapper-0.38.0
	>=dev-perl/List-UtilsBy-0.40.0
	dev-perl/Moose
	>=dev-perl/Path-Tiny-0.48.0
	>=virtual/perl-Scalar-List-Utils-1.330.0
	dev-perl/Try-Tiny
	>=virtual/perl-Unicode-Collate-0.530.0
	virtual/perl-Unicode-Normalize
	dev-perl/namespace-autoclean
	virtual/perl-version
"
DEPEND="
	dev-perl/Module-Build-Tiny
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/Module-Build-Tiny-0.34.0
	test? (
		dev-perl/Dist-Zilla-Plugin-PodWeaver
		>=virtual/perl-Exporter-5.570.0
		virtual/perl-Module-Metadata
		dev-perl/Sort-Versions
		dev-perl/Test-Deep
		dev-perl/Test-Fatal
		dev-perl/Test-Needs
		>=virtual/perl-Test-Simple-0.880.0
		virtual/perl-if
		virtual/perl-parent
	)
"
