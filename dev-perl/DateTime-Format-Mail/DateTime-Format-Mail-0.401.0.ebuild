# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=BOOK
MODULE_VERSION=0.401
inherit perl-module

DESCRIPTION="Convert between DateTime and RFC2822/822 formats"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-solaris"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/DateTime-0.180.0
	dev-perl/Params-Validate
"
DEPEND="${RDEPEND}
	virtual/perl-File-Spec
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? ( >=virtual/perl-Test-Simple-0.880.0 )
"

SRC_TEST=do
