# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=DCONWAY
MODULE_VERSION=1.899
inherit perl-module

DESCRIPTION='Perl module to pluralize English words'

SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="test"

DEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST="do parallel"
PREFER_BUILDPL=no
