# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/User-Identity/User-Identity-0.940.0.ebuild,v 1.2 2015/01/05 21:28:55 zlogene Exp $

EAPI=5

MODULE_AUTHOR=MARKOV
MODULE_VERSION=0.94
inherit perl-module

DESCRIPTION="Maintains info about a physical person"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="
"
#	dev-perl/TimeDate
#	dev-perl/Geography-Countries
DEPEND="${RDEPEND}
	test? (
		>=dev-perl/Test-Pod-1.0.0
	)
"

SRC_TEST=do
