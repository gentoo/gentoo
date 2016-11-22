# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=ETHER
MODULE_VERSION=1.014
inherit perl-module

DESCRIPTION="Author test that validates a package MANIFEST"

SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	virtual/perl-ExtUtils-Manifest
	virtual/perl-File-Spec
	>=dev-perl/Module-Manifest-0.70.0
	virtual/perl-Test-Simple
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.39.0
	test? (
		virtual/perl-ExtUtils-MakeMaker
		virtual/perl-if
	)
"

SRC_TEST="do"
