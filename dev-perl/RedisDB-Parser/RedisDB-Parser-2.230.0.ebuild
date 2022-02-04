# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ZWON
DIST_VERSION=2.23
inherit perl-module

DESCRIPTION="Redis protocol parser for RedisDB"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=virtual/perl-Encode-2.100.0
	dev-perl/Try-Tiny
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.200
	>=virtual/perl-ExtUtils-CBuilder-0.270.0
	test? (
		dev-perl/Test-FailWarnings
		>=dev-perl/Test-Most-0.220.0
		>=virtual/perl-Test-Simple-0.940.0
	)
"
