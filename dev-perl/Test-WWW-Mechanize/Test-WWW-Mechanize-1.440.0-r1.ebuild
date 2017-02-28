# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=PETDANCE
MODULE_VERSION=1.44
inherit perl-module

DESCRIPTION="Testing-specific WWW::Mechanize subclass"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="test"

RDEPEND="
	>=dev-perl/WWW-Mechanize-1.680.0
	dev-perl/Carp-Assert-More
	dev-perl/URI
	>=dev-perl/Test-LongString-0.150.0
"
DEPEND="${RDEPEND}
	test? (
		>=virtual/perl-Test-Simple-0.960.0
		>=dev-perl/HTTP-Server-Simple-0.350.0
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)
"

SRC_TEST="do"
