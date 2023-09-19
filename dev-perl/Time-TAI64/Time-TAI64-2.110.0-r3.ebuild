# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=JOVAL
DIST_VERSION=2.11
inherit perl-module

DESCRIPTION="Time manipulation in the TAI64* formats"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND=""
BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
		virtual/perl-Time-HiRes
	)
"
