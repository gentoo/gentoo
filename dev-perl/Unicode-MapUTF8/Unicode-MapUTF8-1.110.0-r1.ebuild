# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=SNOWHARE
MODULE_VERSION=1.11
inherit perl-module

DESCRIPTION="Conversions to and from arbitrary character sets and UTF8"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

RDEPEND="dev-perl/Unicode-Map
	dev-perl/Unicode-Map8
	dev-perl/Unicode-String
	dev-perl/Jcode"
DEPEND="${RDEPEND}
	dev-perl/Module-Build"
