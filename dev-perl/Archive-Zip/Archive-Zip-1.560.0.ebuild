# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=PHRED
DIST_VERSION=1.56
inherit perl-module

DESCRIPTION="A wrapper that lets you read Zip archive members as if they were files"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND="
	>=virtual/perl-Compress-Raw-Zlib-2.17.0
	virtual/perl-File-Path
	>=virtual/perl-File-Spec-0.800.0
	virtual/perl-File-Temp
	virtual/perl-IO
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-MockModule
		>=virtual/perl-Test-Simple-0.880.0
	)
"
