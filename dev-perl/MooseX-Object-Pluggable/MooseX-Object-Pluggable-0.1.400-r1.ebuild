# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=0.0014
inherit perl-module

DESCRIPTION="Make your classes pluggable"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Module-Pluggable
	dev-perl/Module-Runtime
	dev-perl/Moose
	virtual/perl-Scalar-List-Utils
	dev-perl/Try-Tiny
	dev-perl/namespace-autoclean
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.39.0
	test? (
		virtual/perl-ExtUtils-MakeMaker
		virtual/perl-File-Spec
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.880.0
	)
"
