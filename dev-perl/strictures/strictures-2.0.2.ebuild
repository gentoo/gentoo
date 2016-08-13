# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=HAARG
DIST_VERSION=2.000002
inherit perl-module

DESCRIPTION="Turn on strict and make most warnings fatal"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86 ~ppc-aix ~ppc-macos ~x86-solaris"
IUSE="test minimal"

RDEPEND="
	!minimal? (
		dev-perl/bareword-filehandles
		dev-perl/indirect
		dev-perl/multidimensional
	)
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
