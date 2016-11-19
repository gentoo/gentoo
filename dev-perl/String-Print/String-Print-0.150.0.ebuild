# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=MARKOV
DIST_VERSION=0.15
inherit perl-module

DESCRIPTION="Extensions to printf"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Encode
	dev-perl/Unicode-LineBreak
"
DEPEND="${RDEPEND}
	test? (
		>=virtual/perl-Test-Simple-0.860.0
	)
"
