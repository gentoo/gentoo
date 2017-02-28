# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_VERSION=1.06
DIST_AUTHOR=DRTECH
inherit perl-module

DESCRIPTION="Strip scripting constructs out of HTML"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="test"

RDEPEND="
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
