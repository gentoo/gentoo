# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
MODULE_AUTHOR=LEEJO
MODULE_VERSION=2.00
inherit perl-module

DESCRIPTION='Another HTML code cleaner'
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Regexp-RegGrp-1.1.1_rc
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST="do parallel"
