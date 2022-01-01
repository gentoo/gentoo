# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ROSCH
DIST_VERSION=1.11   # the author made 1.11 follow 1.9, so we need to be creative
inherit perl-module

DESCRIPTION="construct and optionally mail MIME messages"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc ~sparc x86"

RDEPEND="
	virtual/perl-MIME-Base64
	dev-perl/Email-Date-Format
	dev-perl/MIME-Types
	dev-perl/Proc-WaitStat
"
BDEPEND="${RDEPEND}
"

PATCHES=( "${FILESDIR}/${PN}-add-date-header.patch" )
