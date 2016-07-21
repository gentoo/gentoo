# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=PJF
MODULE_VERSION=1.25
inherit perl-module

DESCRIPTION="Run commands simply, with detailed diagnostics"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
		dev-perl/Test-NoWarnings
	)
"

SRC_TEST="do"
