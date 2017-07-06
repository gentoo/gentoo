# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ECARROLL
DIST_VERSION=0.10
inherit perl-module

DESCRIPTION="Extensions to MooseX::Types::DateTime::ButMaintained"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/DateTimeX-Easy-0.85.0
	>=dev-perl/Moose-0.410.0
	>=dev-perl/MooseX-Types-0.40.0
	>=dev-perl/MooseX-Types-DateTime-ButMaintained-0.40.0
	>=dev-perl/Time-Duration-Parse-0.60.0
	>=dev-perl/namespace-clean-0.80.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.420.0
	test? (
		>=virtual/perl-Test-Simple-1.1.10
		>=dev-perl/Test-Exception-0.270.0
	)
"

PATCHES=( "${FILESDIR}/${P}-test.patch" )

src_prepare() {
	sed -i -e 's/use inc::Module::Install/use lib q[.]; use inc::Module::Install/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
