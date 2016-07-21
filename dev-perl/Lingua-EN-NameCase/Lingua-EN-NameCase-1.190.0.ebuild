# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=BARBIE
MODULE_VERSION=1.19
inherit perl-module

DESCRIPTION="Correctly case a person's name from UPERCASE or lowcase"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-IO
		>=virtual/perl-Test-Simple-0.700.0
	)
"

SRC_TEST=do
