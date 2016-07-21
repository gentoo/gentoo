# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=AZAWAWI
MODULE_VERSION=0.15
inherit perl-module

DESCRIPTION="Compile .po files to .mo files"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND="
	test? ( dev-perl/Test-Pod )"

SRC_TEST=do
