# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=YVES
DIST_VERSION=3.015
inherit perl-module

DESCRIPTION="Fast, compact, powerful binary serialization"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-XSLoader
"
# Tester note: ideally you want dev-perl/Sereal-Decoder
# as well, but we can't depend on it because it forms
# a tight cycle if we do
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-7.0.0
	>=virtual/perl-ExtUtils-ParseXS-2.210.0
	virtual/perl-File-Path
	test? (
		virtual/perl-Data-Dumper
		virtual/perl-File-Spec
		virtual/perl-Scalar-List-Utils
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/Test-Warn
	)
"
