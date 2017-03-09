# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DIST_AUTHOR=CHROMATIC
DIST_VERSION=1.20170117
inherit perl-module

DESCRIPTION="enable all of the features of Modern Perl with one import"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RDEPEND="virtual/perl-IO
	>=virtual/perl-autodie-2.220.0"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/Module-Build-0.280.0
	test? (
		>=virtual/perl-Test-Simple-0.980.0
	)"
