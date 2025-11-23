# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MARKOV
DIST_VERSION=1.41
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Pluggable, multilingual handler driven problem reporting system"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/Devel-GlobalDestruction-0.90.0
	>=dev-perl/Log-Report-Optional-1.70.0
	>=dev-perl/String-Print-0.910.0
"
BDEPEND="
	${RDEPEND}
"
