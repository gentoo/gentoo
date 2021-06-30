# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=PERRIN
DIST_VERSION=0.35
inherit perl-module

DESCRIPTION="Add contextual fetches to DBI"

SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc ppc64 sparc x86 ~x86-solaris"
IUSE=""

RDEPEND="
	dev-perl/DBI
	dev-perl/Class-WhiteHole
	dev-perl/DBIx-ContextualFetch
	virtual/perl-Test-Simple
	>=dev-perl/Class-Data-Inheritable-0.02
"
BDEPEND="${RDEPEND}"

PERL_RM_FILES=( t/pod-coverage.t )
