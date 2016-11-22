# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=DAGOLDEN
DIST_VERSION=0.008
inherit perl-module

DESCRIPTION="List prereqs conditional on operating system"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Dist-Zilla-5.22.0
	dev-perl/Moose
	>=virtual/perl-Scalar-List-Utils-1.330.0
	dev-perl/namespace-autoclean
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		virtual/perl-File-Spec
		dev-perl/Params-Util
		dev-perl/Sub-Exporter
		dev-perl/Test-Deep
		dev-perl/Test-Deep-JSON
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/YAML-Tiny
	)
"
