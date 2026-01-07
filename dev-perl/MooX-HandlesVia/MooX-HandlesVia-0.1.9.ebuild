# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TOBYINK
DIST_VERSION=0.001009
inherit perl-module

DESCRIPTION="NativeTrait-like behavior for Moo"

SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ppc ~riscv x86 ~x64-macos"

RDEPEND="
	dev-perl/Class-Method-Modifiers
	>=dev-perl/Data-Perl-0.2.6
	dev-perl/Module-Runtime
	>=dev-perl/Moo-1.3.0
	dev-perl/Role-Tiny
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/MooX-Types-MooseLike-0.230.0
		dev-perl/Test-Exception
		dev-perl/Test-Fatal
		virtual/perl-Test-Simple
	)
"
