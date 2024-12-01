# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=HAARG
DIST_VERSION=0.013
inherit perl-module

DESCRIPTION="Make your Moo-based object constructors blow up on unknown attributes"

SLOT="0"
KEYWORDS="amd64 ~loong ~riscv x86"

RDEPEND="
	>=dev-perl/Moo-2.4.0
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-IO
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.880.0
	)
"
