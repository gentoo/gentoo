# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=BOBTFISH
MODULE_VERSION=0.13
inherit perl-module

DESCRIPTION="Keep imports out of your namespace"

SLOT="0"
KEYWORDS="amd64 ~arm ppc x86 ~x64-macos"
IUSE="test"

RDEPEND=">=dev-perl/namespace-clean-0.200
	 >=dev-perl/Moose-1.990
	>=dev-perl/B-Hooks-EndOfScope-0.07"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.31
	test? (
		>=dev-perl/Moose-0.56
		dev-perl/Sub-Name
	)"

SRC_TEST=do
