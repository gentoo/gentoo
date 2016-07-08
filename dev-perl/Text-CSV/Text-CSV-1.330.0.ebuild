# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=MAKAMAKA
MODULE_VERSION=1.33
inherit perl-module

DESCRIPTION="Manipulate comma-separated value strings"

SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86"
IUSE="test"

RDEPEND=""
DEPEND="test? ( dev-perl/Test-Pod )"

SRC_TEST=do
