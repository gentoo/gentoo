# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=0.036
inherit perl-module

DESCRIPTION="Add contributor names from git to your distribution"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/Dist-Zilla-4.300.39
	>=dev-perl/Git-Wrapper-0.38.0
	>=dev-perl/List-UtilsBy-0.40.0
	dev-perl/Moose
	>=dev-perl/Path-Tiny-0.48.0
	>=virtual/perl-Scalar-List-Utils-1.330.0
	dev-perl/Try-Tiny
	dev-perl/namespace-autoclean
"
DEPEND="
	dev-perl/Module-Build-Tiny
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.34.0
	test? (
		dev-perl/Dist-Zilla-Plugin-PodWeaver
		>=virtual/perl-Exporter-5.570.0
		dev-perl/Sort-Versions
		dev-perl/Test-Deep
		dev-perl/Test-Fatal
		dev-perl/Test-Needs
		>=virtual/perl-Test-Simple-0.880.0
	)
"
