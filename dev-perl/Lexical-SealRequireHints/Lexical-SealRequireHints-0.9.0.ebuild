# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=ZEFRAM
MODULE_VERSION=0.009
inherit perl-module

DESCRIPTION="Prevent leakage of lexical hints"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE="test"

RDEPEND="
	!<dev-perl/B-Hooks-OP-Check-0.190.0
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		>=virtual/perl-Test-Simple-0.410.0
	)
"

SRC_TEST="do"
