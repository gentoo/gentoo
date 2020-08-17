# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DMUEY
DIST_VERSION=0.45
inherit perl-module

DESCRIPTION="uses File::Copy to recursively copy dirs"

SLOT="0"
KEYWORDS="~amd64 ~arm ~s390 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-File-Spec
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Temp
		dev-perl/Path-Tiny
		dev-perl/Test-Deep
		dev-perl/Test-Fatal
		dev-perl/Test-File
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/Test-Warnings
	)
"
