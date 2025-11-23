# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MARKOV
DIST_VERSION=0.96

inherit perl-module

DESCRIPTION="Extensions to printf"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/TimeDate-2.300.0
	dev-perl/HTML-Parser
	dev-perl/Unicode-LineBreak
"
BDEPEND="${RDEPEND}"
