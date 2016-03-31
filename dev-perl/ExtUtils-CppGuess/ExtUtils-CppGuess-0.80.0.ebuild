# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR="ETJ"
DIST_VERSION="0.08"
inherit perl-module

DESCRIPTION="Guess C++ compiler and flags"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-perl/Capture-Tiny"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
	test? ( virtual/perl-autodie
		virtual/perl-Test-Simple
		virtual/perl-File-Path
		virtual/perl-File-Spec
		virtual/perl-ExtUtils-MakeMaker
		virtual/perl-ExtUtils-Manifest )"
