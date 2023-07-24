# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TOBYINK
DIST_VERSION=0.008
inherit perl-module

DESCRIPTION="Role callbacks"

SLOT="0"
KEYWORDS="~amd64 ~hppa ppc ~riscv x86"

RDEPEND="
	dev-perl/Class-Method-Modifiers
	>=virtual/perl-Scalar-List-Utils-1.450.0
"
BDEPEND="
	${RDEPEND}
	test? (
		dev-perl/Class-Tiny
		dev-perl/Test-Requires
		dev-perl/Role-Basic
		dev-perl/Role-Tiny
	)
"
