# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MARKOV
DIST_VERSION=0.93

inherit perl-module

DESCRIPTION="Extensions to printf"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/TimeDate-2.300.0
	virtual/perl-Encode
	dev-perl/HTML-Parser
	dev-perl/Unicode-LineBreak
"
DEPEND="${RDEPEND}
	test? (
		>=virtual/perl-Test-Simple-0.860.0
	)
"
