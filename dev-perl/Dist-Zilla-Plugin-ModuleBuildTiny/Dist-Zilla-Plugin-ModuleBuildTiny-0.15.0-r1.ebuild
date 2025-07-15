# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=LEONT
DIST_VERSION=0.015
inherit perl-module

DESCRIPTION="Build a Build.PL that uses Module::Build::Tiny"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/Dist-Zilla-4.300.39
	>=dev-perl/Module-Build-Tiny-0.39.0
	dev-perl/Moose
	dev-perl/MooseX-Types-Perl
	>=virtual/perl-Scalar-List-Utils-1.330.0
"
DEPEND="
	dev-perl/Module-Build-Tiny
"
BDEPEND="${RDEPEND}
	test? (
		dev-perl/Path-Tiny
		dev-perl/Test-Deep
		dev-perl/Test-Fatal
	)
"
