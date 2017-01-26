# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=YVES
DIST_VERSION=3.015
inherit perl-module

DESCRIPTION="Fast, compact, powerful binary (de-)serialization"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Sereal-Encoder-3.15.0
	>=dev-perl/Sereal-Decoder-3.15.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Data-Dumper
		virtual/perl-File-Spec
		virtual/perl-Scalar-List-Utils
		dev-perl/Test-LongString
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/Test-Warn
	)
"
