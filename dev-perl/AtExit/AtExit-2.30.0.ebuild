# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=NEILB
DIST_VERSION=2.03
inherit perl-module

DESCRIPTION="atexit() function to register exit-callbacks"
LICENSE="|| ( Artistic Artistic-2 )"

SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Exporter
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Capture-Tiny
		virtual/perl-Test-Simple
	)
"
