# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=ETHER
MODULE_VERSION=0.50
inherit perl-module

DESCRIPTION="Easily create test classes in an xUnit/JUnit style"

SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="test"

RDEPEND="
	>=virtual/perl-Attribute-Handlers-0.770.0
	virtual/perl-Carp
	virtual/perl-File-Spec
	>=dev-perl/MRO-Compat-0.110.0
	dev-perl/Module-Runtime
	>=virtual/perl-Storable-2.40.0
	virtual/perl-Test-Simple
	dev-perl/Try-Tiny
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-IO
		virtual/perl-Test-Simple
		>=dev-perl/Test-Exception-0.250.0
	)
"

SRC_TEST="do parallel"
