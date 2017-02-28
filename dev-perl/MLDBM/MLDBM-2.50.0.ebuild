# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=CHORNY
DIST_VERSION=2.05
inherit perl-module

DESCRIPTION="A multidimensional/tied hash Perl Module"

SLOT="0"
KEYWORDS="alpha amd64 ~arm ia64 ppc ppc64 ~s390 sparc x86 ~x86-fbsd"
IUSE="test"

RDEPEND="
	>=virtual/perl-Data-Dumper-2.80.0
	virtual/perl-Carp
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? ( virtual/perl-Test-Simple )
"
