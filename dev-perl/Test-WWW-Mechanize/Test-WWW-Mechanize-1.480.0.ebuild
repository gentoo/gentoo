# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=PETDANCE
DIST_VERSION=1.48
inherit perl-module

DESCRIPTION="Testing-specific WWW::Mechanize subclass"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Carp-Assert-More
	dev-perl/HTML-Parser
	>=dev-perl/libwww-perl-6.200.0
	>=dev-perl/Test-LongString-0.150.0
	>=virtual/perl-Test-Simple-0.960.0
	dev-perl/URI
	>=dev-perl/WWW-Mechanize-1.680.0
	virtual/perl-parent
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/HTTP-Server-Simple-0.420.0
	)
"
PERL_RM_FILES=( "t/pod.t" "t/pod-coverage.t" )
