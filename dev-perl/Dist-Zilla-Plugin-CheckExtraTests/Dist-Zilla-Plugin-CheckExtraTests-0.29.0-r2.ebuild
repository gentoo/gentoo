# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DAGOLDEN
DIST_VERSION=0.029
inherit perl-module

DESCRIPTION="check xt tests before release"
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="Apache-2.0"

RDEPEND="
	>=dev-perl/Dist-Zilla-4.300.0
	dev-perl/File-pushd
	>=dev-perl/Moose-2.0.0
	dev-perl/Path-Iterator-Rule
	>=dev-perl/Path-Tiny-0.13.0
	>=virtual/perl-Test-Harness-3.0.0
	>=dev-perl/namespace-autoclean-0.90.0
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	test? (
		dev-perl/Capture-Tiny
		dev-perl/Params-Util
		dev-perl/Sub-Exporter
		dev-perl/Test-Requires
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/Try-Tiny
	)
"
