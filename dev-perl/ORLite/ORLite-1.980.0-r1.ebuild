# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/ORLite/ORLite-1.980.0-r1.ebuild,v 1.1 2014/08/26 19:23:30 axs Exp $

EAPI=5

MODULE_AUTHOR=ADAMK
MODULE_VERSION=1.98
inherit perl-module

DESCRIPTION="Extremely light weight SQLite-specific ORM"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

COMMON_DEPEND="
	>=virtual/perl-File-Path-2.08
	>=virtual/perl-File-Temp-0.20
	>=dev-perl/Params-Util-1
	>=dev-perl/DBI-1.607
	>=dev-perl/DBD-SQLite-1.27
	>=dev-perl/File-Remove-1.40
"
DEPEND="
	${COMMON_DEPEND}
	test? (
		>=dev-perl/Test-Script-1.06
	)
"
RDEPEND="
	${COMMON_DEPEND}
"

SRC_TEST=do
