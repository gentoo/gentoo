# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=SSOTKA
MODULE_VERSION=0.05
inherit perl-module

DESCRIPTION="Perl extension for refactoring Perl code"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
PATCHES=( "${FILESDIR}/${P}-perl526.patch" )
SRC_TEST="do"
