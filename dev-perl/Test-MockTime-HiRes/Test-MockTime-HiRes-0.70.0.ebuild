# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=TARAO
DIST_VERSION=0.07
inherit perl-module

DESCRIPTION="Replace actual time with simulated high resolution time"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/Test-MockTime
	virtual/perl-Test-Simple
	virtual/perl-Time-HiRes
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.35.0
	test? (
		dev-perl/Test-Class
		dev-perl/Test-Requires
	)
"
