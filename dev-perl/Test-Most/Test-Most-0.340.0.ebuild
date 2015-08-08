# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=OVID
MODULE_VERSION=0.34
inherit perl-module

DESCRIPTION="Most commonly needed test functions and features"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE=""

RDEPEND="
	>=dev-perl/Exception-Class-1.140.0
	>=dev-perl/Test-Warn-0.230.0
	>=dev-perl/Test-Deep-0.106
	>=dev-perl/Test-Differences-0.610.0
	>=dev-perl/Test-Exception-0.310.0
	>=virtual/perl-Test-Harness-3.210.0
	>=virtual/perl-Test-Simple-0.88
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.400.0
"

SRC_TEST=do
