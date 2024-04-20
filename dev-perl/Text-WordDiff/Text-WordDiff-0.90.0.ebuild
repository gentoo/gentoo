# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TIMK
DIST_VERSION=0.09
inherit perl-module

DESCRIPTION="Track changes between documents"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/Algorithm-Diff
	dev-perl/HTML-Parser
	virtual/perl-Term-ANSIColor
"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
	virtual/perl-ExtUtils-MakeMaker
"
