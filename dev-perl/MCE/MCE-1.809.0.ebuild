# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=MARIOROY
DIST_VERSION=1.809
inherit perl-module

DESCRIPTION="Many-Core Engine providing parallel processing capabilities"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-File-Path
	virtual/perl-Getopt-Long
	virtual/perl-IO
	virtual/perl-Scalar-List-Utils
	virtual/perl-Socket
	>=virtual/perl-Storable-2.40.0
	virtual/perl-Time-HiRes
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
