# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=ETHER
MODULE_VERSION=1.20150614
inherit perl-module

DESCRIPTION="Attempt to recover from people calling UNIVERSAL::isa as a function"

SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~x86 ~ppc-aix"
IUSE="test"

RDEPEND="
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-Test-Simple
	)
"

SRC_TEST="do parallel"
