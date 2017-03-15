# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=NUFFIN
DIST_VERSION=0.01
inherit perl-module

DESCRIPTION="Functions for working with IO::Handle like objects"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

RDEPEND="
	dev-perl/IO-String
	virtual/perl-Scalar-List-Utils
	dev-perl/Sub-Exporter
	dev-perl/asa
	virtual/perl-parent
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-1.1.10
	)
"
