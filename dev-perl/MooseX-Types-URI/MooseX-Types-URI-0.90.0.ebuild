# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=0.09
inherit perl-module

DESCRIPTION="URI related types and coercions for Moose"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/MooseX-Types-0.400.0
	virtual/perl-Scalar-List-Utils
	dev-perl/URI
	dev-perl/URI-FromHash
	virtual/perl-if
	dev-perl/namespace-autoclean
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.7.0
	test? (
		virtual/perl-ExtUtils-MakeMaker
		virtual/perl-File-Spec
		dev-perl/Moose
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/Test-Needs
		dev-perl/Test-Without-Module
	)
"
