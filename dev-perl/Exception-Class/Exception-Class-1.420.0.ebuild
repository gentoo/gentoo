# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=DROLSKY
DIST_VERSION=1.42
DIST_EXAMPLES=("bench/*")
inherit perl-module

DESCRIPTION="A module that allows you to declare real exception classes in Perl"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos"
IUSE="test"

RDEPEND="
	>=dev-perl/Class-Data-Inheritable-0.20.0
	>=dev-perl/Devel-StackTrace-2.0.0
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.960.0
	)
"
