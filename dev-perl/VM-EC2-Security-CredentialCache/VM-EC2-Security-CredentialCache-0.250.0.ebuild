# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=RCONOVER
DIST_VERSION=0.25
inherit perl-module

DESCRIPTION="Cache credentials respecting expiration time for IAM roles"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-perl/DateTime-Format-ISO8601
	dev-perl/VM-EC2
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
