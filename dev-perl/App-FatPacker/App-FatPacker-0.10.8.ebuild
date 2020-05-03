# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MSTROUT
DIST_VERSION=0.010008
inherit perl-module

DESCRIPTION="pack your dependencies onto your script file"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-File-Path
	virtual/perl-File-Spec
	virtual/perl-Getopt-Long
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Temp
		>=virtual/perl-Test-Simple-0.820.0
	)
"
