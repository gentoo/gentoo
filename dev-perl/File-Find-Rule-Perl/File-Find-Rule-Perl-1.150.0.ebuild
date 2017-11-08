# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ETHER
DIST_VERSION=1.15

inherit perl-module

DESCRIPTION="Common rules for searching for Perl things"

SLOT="0"
KEYWORDS="amd64 ~arm hppa ppc ppc64 sparc x86"
IUSE="test"

RDEPEND="
	>=virtual/perl-CPAN-Meta-1.380.0
	>=dev-perl/File-Find-Rule-0.200.0
	>=virtual/perl-File-Spec-0.820.0
	>=dev-perl/Params-Util-0.380.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
