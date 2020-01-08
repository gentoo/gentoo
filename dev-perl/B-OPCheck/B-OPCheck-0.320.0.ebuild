# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ETHER
DIST_VERSION=0.32
inherit perl-module

DESCRIPTION="PL_check hacks using Perl callbacks"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/B-Utils-0.80.0
	virtual/perl-Carp
	virtual/perl-Scalar-List-Utils
	dev-perl/Scope-Guard
	virtual/perl-XSLoader
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/ExtUtils-Depends-0.302.0
	test? (
		virtual/perl-File-Spec
		virtual/perl-Module-Metadata
		virtual/perl-Test-Simple
	)
"
