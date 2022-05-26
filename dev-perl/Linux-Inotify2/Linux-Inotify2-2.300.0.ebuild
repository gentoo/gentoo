# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MLEHMANN
DIST_VERSION=2.3
inherit perl-module

DESCRIPTION="scalable directory/file change notification"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"

RDEPEND="
	dev-perl/common-sense
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
