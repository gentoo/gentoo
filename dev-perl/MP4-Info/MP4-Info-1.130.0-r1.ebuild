# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_VERSION=1.13
DIST_AUTHOR=JHAR
inherit perl-module

DESCRIPTION="Fetch info from MPEG-4 files (.mp4, .m4a, .m4p, .3gp)"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	virtual/perl-Encode
	dev-perl/IO-String
"
BDEPEND="${RDEPEND}
"
