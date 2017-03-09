# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SYOHEX
DIST_VERSION=0.07
inherit perl-module

DESCRIPTION="Check the compiler's availability"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Exporter
	virtual/perl-ExtUtils-CBuilder
	virtual/perl-File-Temp
	virtual/perl-parent
"
DEPEND="
	${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.35.0
	test? (
		>=virtual/perl-Test-Simple-0.980.0
	)
"
