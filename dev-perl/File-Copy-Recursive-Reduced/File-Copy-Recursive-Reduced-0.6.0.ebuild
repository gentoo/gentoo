# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=JKEENAN
DIST_VERSION=0.006
inherit perl-module

DESCRIPTION="Recursive copying of files and directories within Perl 5 toolchain"

SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv x86"

RDEPEND="
	virtual/perl-File-Spec
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Capture-Tiny
		virtual/perl-File-Temp
		dev-perl/Path-Tiny
		>=virtual/perl-Test-Simple-0.440.0
	)
"
