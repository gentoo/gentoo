# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=GTERMARS
DIST_VERSION=0.15

inherit perl-module

DESCRIPTION="XS based JavaScript minifier"

SLOT="0"
KEYWORDS="amd64 ~riscv ~x86"

RDEPEND=""
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		virtual/perl-IO
		>=dev-perl/Test-DiagINC-0.2.0
	)
"
