# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=BOBTFISH
MODULE_VERSION=1.4

inherit perl-module

DESCRIPTION="Check the presence of tabs in your project"

SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}"

SRC_TEST="do"
