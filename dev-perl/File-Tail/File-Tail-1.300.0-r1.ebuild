# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MGRABNAR
DIST_VERSION=1.3
inherit perl-module

DESCRIPTION="Perl extension for reading from continously updated files"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ppc ppc64 ~riscv sparc x86"

RDEPEND="
	>=virtual/perl-Time-HiRes-1.120.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

mydoc="ToDo"
