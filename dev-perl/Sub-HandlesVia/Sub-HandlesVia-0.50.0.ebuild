# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TOBYINK
DIST_VERSION=0.050000
inherit perl-module

DESCRIPTION="Alternative handles_via implementation"
SLOT="0"
KEYWORDS="~amd64 ~hppa ppc ~riscv ~x86"

RDEPEND="
	dev-perl/Class-Method-Modifiers
	dev-perl/Exporter-Tiny
	>=virtual/perl-Scalar-List-Utils-1.540.0
	>=dev-perl/Role-Hooks-0.8.0
	dev-perl/Role-Tiny
	>=dev-perl/Type-Tiny-1.4.0
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	test? (
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.960.0
		dev-perl/Test-Requires
	)
"
