# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ECARROLL
DIST_VERSION=0.16
inherit perl-module

DESCRIPTION="DateTime related constraints and coercions for Moose"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/DateTime-0.43.02
	>=dev-perl/DateTime-Format-DateParse-0.04
	>=dev-perl/DateTime-Format-Flexible-0.05
	>=dev-perl/DateTime-Format-Natural-0.71
	>=dev-perl/DateTime-Locale-0.40.01
	>=dev-perl/DateTime-TimeZone-0.77.01
	>=dev-perl/DateTimeX-Easy-0.082
	>=dev-perl/Moose-0.41
	>=dev-perl/MooseX-Types-0.300.0
	dev-perl/namespace-autoclean
	>=dev-perl/Olson-Abbreviations-0.30.0
"
DEPEND="${RDEPEND}
	test? (
		>=dev-perl/Test-Exception-0.27
		>=virtual/perl-Test-Simple-1.1.10
		>=dev-perl/Time-Duration-Parse-0.06
	)
"

src_prepare() {
	sed -i -e 's/use inc::Module::Install/use lib q[.]; use inc::Module::Install/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
