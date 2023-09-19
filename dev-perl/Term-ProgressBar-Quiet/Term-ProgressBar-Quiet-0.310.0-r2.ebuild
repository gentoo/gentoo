# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=LBROCARD
DIST_VERSION=0.31
inherit perl-module

DESCRIPTION="Provide a progress meter if run interactively"

SLOT="0"
KEYWORDS="amd64 ~riscv x86"

RDEPEND="
	dev-perl/IO-Interactive
	dev-perl/Term-ProgressBar
	dev-perl/Test-MockObject
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
