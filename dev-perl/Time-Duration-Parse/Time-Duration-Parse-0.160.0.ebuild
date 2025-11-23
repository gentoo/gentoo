# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NEILB
DIST_VERSION=0.16
inherit perl-module

DESCRIPTION="Parse string that represents time duration"

SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/Time-Duration
	)
"
