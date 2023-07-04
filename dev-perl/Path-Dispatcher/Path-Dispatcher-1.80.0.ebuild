# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=1.08
inherit perl-module

DESCRIPTION="Flexible and extensible dispatch"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Moo
	dev-perl/MooX-TypeTiny
	virtual/perl-Scalar-List-Utils
	dev-perl/Try-Tiny
	dev-perl/Type-Tiny
"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build-Tiny
	virtual/perl-ExtUtils-MakeMaker
"
