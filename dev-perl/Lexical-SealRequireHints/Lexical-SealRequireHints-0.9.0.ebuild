# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Lexical-SealRequireHints/Lexical-SealRequireHints-0.9.0.ebuild,v 1.2 2015/06/13 22:27:39 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=ZEFRAM
MODULE_VERSION=0.009
inherit perl-module

DESCRIPTION="Prevent leakage of lexical hints"

SLOT="0"
KEYWORDS="~amd64 ~x86"
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
