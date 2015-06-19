# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Validate-Tiny/Validate-Tiny-1.015.ebuild,v 1.1 2015/02/22 00:43:17 monsieurp Exp $
EAPI=5

MODULE_AUTHOR=MINIMAL
MODULE_VERSION=1.015
inherit perl-module

DESCRIPTION="Minimalistic data validation"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	>=dev-perl/List-MoreUtils-0.330.0
	test? (
		virtual/perl-Test-Simple
	)"

SRC_TEST="do"
