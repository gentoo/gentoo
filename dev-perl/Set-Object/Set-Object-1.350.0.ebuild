# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=RURBAN
MODULE_VERSION=1.35
inherit perl-module

DESCRIPTION="set of objects and strings"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST="do parallel"
