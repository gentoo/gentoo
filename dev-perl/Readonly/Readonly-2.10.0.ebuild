# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SANKO
DIST_VERSION=2.01
inherit perl-module

DESCRIPTION="Facility for creating read-only scalars, arrays, hashes"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-perl/Module-Build-Tiny-0.35.0
	test? ( virtual/perl-Test-Simple )
"
