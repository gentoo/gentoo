# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=CHORNY
DIST_VERSION=1.93
inherit perl-module

DESCRIPTION="A persistence framework for session data"

SLOT="0"
KEYWORDS="~alpha amd64 ~ppc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Digest-MD5
	virtual/perl-File-Temp
	virtual/perl-IO
	virtual/perl-Storable
"
DEPEND="
	dev-perl/Module-Build
"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		>=dev-perl/Test-Deep-0.82.0
		>=dev-perl/Test-Exception-0.150.0
		>=virtual/perl-Test-Simple-0.470.0
	)
"
