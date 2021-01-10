# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MARKSTOS
DIST_VERSION=3.12
inherit perl-module

DESCRIPTION="Dispatch requests to CGI::Application based objects"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
RDEPEND="
	>=dev-perl/CGI-Application-4.500.0
	dev-perl/CGI-PSGI
	>=dev-perl/Exception-Class-1.200.0
	dev-perl/HTTP-Exception
	dev-perl/Try-Tiny
	>=virtual/perl-version-0.820.0
"
DEPEND="dev-perl/Module-Build"
# Todo: add Apache::Test and mod_perl w/
# USE=minimal, currently can't due to mod_perl
# breaking w/ ranlib fun
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.380.0
	test? (
		>=dev-perl/Plack-0.995.600
		dev-perl/Test-LongString
		virtual/perl-Test-Simple
	)
"
