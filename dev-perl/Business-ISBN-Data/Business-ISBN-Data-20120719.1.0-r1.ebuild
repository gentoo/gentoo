# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Business-ISBN-Data/Business-ISBN-Data-20120719.1.0-r1.ebuild,v 1.1 2014/08/26 14:46:26 axs Exp $

EAPI=5

MODULE_AUTHOR=BDFOY
MODULE_VERSION=20120719.001
inherit perl-module

DESCRIPTION="Data pack for Business::ISBN"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	test? (
		>=virtual/perl-Test-Simple-0.950.0
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)
"

SRC_TEST=do
