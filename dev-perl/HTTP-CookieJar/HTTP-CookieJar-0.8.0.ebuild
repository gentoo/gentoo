# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DAGOLDEN
DIST_VERSION=0.008
inherit perl-module

DESCRIPTION="A minimalist HTTP user agent cookie jar"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test minimal"

RDEPEND="
	!minimal? ( dev-perl/Mozilla-PublicSuffix )
	virtual/perl-Carp
	dev-perl/HTTP-Date
	>=virtual/perl-Time-Local-1.190.100
	virtual/perl-parent
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	test? (
		!minimal? (
			>=virtual/perl-CPAN-Meta-2.120.900
			dev-perl/HTTP-Message

		)
		virtual/perl-File-Spec
		dev-perl/Test-Deep
		dev-perl/Test-Requires
		>=virtual/perl-Test-Simple-0.960.0
		dev-perl/URI
	)
"
