# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_VERSION=1.13
MODULE_AUTHOR=JHAR
inherit perl-module

DESCRIPTION="Fetch info from MPEG-4 files (.mp4, .m4a, .m4p, .3gp)"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	virtual/perl-Encode
	dev-perl/IO-String
"
DEPEND="${RDEPEND}
"

SRC_TEST=do
