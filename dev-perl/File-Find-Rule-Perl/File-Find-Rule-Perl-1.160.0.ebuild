# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=1.16

inherit perl-module

DESCRIPTION="Common rules for searching for Perl things"

SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ppc64 sparc ~x86"

RDEPEND="
	>=virtual/perl-CPAN-Meta-1.380.0
	>=dev-perl/File-Find-Rule-0.200.0
	>=virtual/perl-File-Spec-0.820.0
	>=dev-perl/Params-Util-0.380.0
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
