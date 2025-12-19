# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=1.09
inherit perl-module

DESCRIPTION="Parse and examine a Perl distribution MANIFEST file"

SLOT="0"
KEYWORDS="amd64 ~riscv x86"

RDEPEND="
	virtual/perl-Carp
	>=virtual/perl-File-Spec-0.800.0
	>=dev-perl/Params-Util-0.100.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Exception
		dev-perl/Test-Warn
	)
"
