# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DAMS
DIST_VERSION=0.32
inherit perl-module

DESCRIPTION="IO::Socket with read/write timeout"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/PerlIO-via-Timeout-0.320.0
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.39.0
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-IO
		virtual/perl-Test-Simple
		dev-perl/Test-TCP
	)
"
