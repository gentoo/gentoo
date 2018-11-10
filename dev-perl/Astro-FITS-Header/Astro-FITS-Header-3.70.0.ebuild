# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=TJENNESS
MODULE_VERSION=3.07
inherit perl-module

DESCRIPTION="Interface to FITS headers"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 arm hppa ~mips ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-perl/Module-Build
"

SRC_TEST="do"
