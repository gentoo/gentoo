# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=0.10
inherit perl-module

DESCRIPTION="URI related types and coercions for Moose"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/MooseX-Types-0.400.0
	dev-perl/URI
	dev-perl/URI-FromHash
	dev-perl/namespace-autoclean
"
BDEPEND="
	${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.7.0
	test? (
		dev-perl/Moose
		>=virtual/perl-Test-Simple-0.880.0
	)
"
