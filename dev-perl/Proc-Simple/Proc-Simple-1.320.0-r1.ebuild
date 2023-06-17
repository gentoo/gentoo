# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MSCHILLI
DIST_VERSION=1.32
DIST_EXAMPLES=( "eg/*" )
inherit perl-module

DESCRIPTION="Launch and control background processes"

SLOT="0"
KEYWORDS="amd64 ppc ~riscv x86"

RDEPEND="virtual/perl-IO"
BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
