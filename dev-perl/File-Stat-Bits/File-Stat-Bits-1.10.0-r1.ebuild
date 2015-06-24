# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/File-Stat-Bits/File-Stat-Bits-1.10.0-r1.ebuild,v 1.2 2015/06/24 14:23:13 monsieurp Exp $

EAPI=5

MODULE_AUTHOR=FEDOROV
MODULE_VERSION=1.01
inherit perl-module

DESCRIPTION="File stat bit mask constants"

LICENSE="|| ( GPL-2 GPL-3 )" # GPL-2+
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

SRC_TEST="do"
