# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MATEU
DIST_VERSION=0.29
inherit perl-module

DESCRIPTION="Some Moosish types and a type builder"

SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

RDEPEND="
	>=dev-perl/strictures-2
	>=dev-perl/Module-Runtime-0.14.0
	>=dev-perl/Moo-1.4.2
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/Test-Fatal-0.3.0
		>=virtual/perl-Test-Simple-0.960.0
	)
"
