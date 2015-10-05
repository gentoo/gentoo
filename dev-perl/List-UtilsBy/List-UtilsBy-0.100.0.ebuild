# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=PEVANS
MODULE_VERSION=0.10
inherit perl-module

DESCRIPTION="Higher-order list utility functions"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	>=dev-perl/Module-Build-0.380.0
	test? (
		dev-perl/Test-Pod
	)
"

SRC_TEST=do
