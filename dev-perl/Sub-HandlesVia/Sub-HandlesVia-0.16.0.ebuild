# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TOBYINK
DIST_VERSION=0.016
inherit perl-module

DESCRIPTION="alternative handles_via implementation"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc"

RDEPEND="
	dev-perl/Class-Method-Modifiers
	dev-perl/Class-Tiny
	dev-perl/Exporter-Tiny
	>=virtual/perl-Scalar-List-Utils-1.540.0
	dev-perl/Role-Tiny
	>=dev-perl/Type-Tiny-1.4.0
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	test? (
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.960.0
		dev-perl/Test-Requires
	)
"
