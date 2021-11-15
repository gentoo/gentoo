# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NEILB
DIST_VERSION=0.19
inherit perl-module

DESCRIPTION="get the full path to a locally installed module"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	virtual/perl-File-Spec
	virtual/perl-Exporter
	virtual/perl-Getopt-Long
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Devel-FindPerl
		>=virtual/perl-Test-Simple-0.880.0
	)
"
