# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=RIBASUSHI
MODULE_VERSION=0.25
inherit perl-module

DESCRIPTION="Keep imports and functions out of your namespace"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~x86 ~ppc-aix ~x64-macos"
IUSE="test"

RDEPEND="
	>=dev-perl/B-Hooks-EndOfScope-0.120.0
	>=dev-perl/Package-Stash-0.220.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.310.0
	virtual/perl-ExtUtils-CBuilder
	test? (
		>=virtual/perl-Test-Simple-0.880.0
	)
"

SRC_TEST=do
