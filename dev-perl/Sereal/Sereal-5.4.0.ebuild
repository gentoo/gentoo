# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=YVES
DIST_VERSION=5.004
inherit perl-module

DESCRIPTION="Fast, compact, powerful binary (de-)serialization"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc ppc64 sparc x86"

RDEPEND="
	>=dev-perl/Sereal-Encoder-${PV}
	>=dev-perl/Sereal-Decoder-${PV}
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Data-Dumper
		virtual/perl-File-Spec
		virtual/perl-Scalar-List-Utils
		dev-perl/Test-Deep
		dev-perl/Test-Differences
		dev-perl/Test-LongString
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/Test-Warn
	)
"
