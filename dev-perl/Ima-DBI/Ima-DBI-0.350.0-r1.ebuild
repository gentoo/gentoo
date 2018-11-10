# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=PERRIN
MODULE_VERSION=0.35
inherit perl-module

DESCRIPTION="Add contextual fetches to DBI"

SLOT="0"
KEYWORDS="amd64 ia64 ~ppc ppc64 sparc x86 ~x86-solaris"
IUSE=""

RDEPEND="dev-perl/DBI
	dev-perl/Class-WhiteHole
	dev-perl/DBIx-ContextualFetch
	virtual/perl-Test-Simple
	>=dev-perl/Class-Data-Inheritable-0.02"
DEPEND="${RDEPEND}"

SRC_TEST="do"
