# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Finance-Quote/Finance-Quote-1.290.0.ebuild,v 1.2 2014/06/12 18:21:58 zlogene Exp $

EAPI=5

MODULE_AUTHOR=ECOCODE
MODULE_VERSION=1.29
inherit perl-module

DESCRIPTION="Get stock and mutual fund quotes from various exchanges"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~x86"
IUSE="test"

RDEPEND="dev-perl/libwww-perl
	dev-perl/HTML-Tree
	dev-perl/HTML-TableExtract
	dev-perl/Crypt-SSLeay"

DEPEND="${RDEPEND}
	test? ( dev-perl/Date-Calc )"

SRC_TEST="do"
