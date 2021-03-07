# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ETHER
DIST_VERSION=0.31
inherit perl-module

DESCRIPTION="Visitor style traversal of Perl data structures"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Moose-0.890.0
	virtual/perl-Scalar-List-Utils
	dev-perl/Sub-Name
	>=dev-perl/Tie-ToObject-0.10.0
	>=dev-perl/namespace-clean-0.190.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		dev-perl/Test-Needs
		>=virtual/perl-Test-Simple-0.880.0
		virtual/perl-Tie-RefHash
	)
"
