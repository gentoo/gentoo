# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=RJBS
DIST_VERSION=2.101463
inherit perl-module

DESCRIPTION="an MVP config reader for .ini files"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

# r: Config::INI::Reader -> Config-INI
# r: Config::MVP::Reader -> Config-MVP
# r: Config::MVP::Reader::Findable -> Config-MVP
RDEPEND="
	dev-perl/Config-INI
	>=dev-perl/Config-MVP-2
	dev-perl/Moose
	virtual/perl-parent
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		>=virtual/perl-Test-Simple-0.960.0
	)
"
