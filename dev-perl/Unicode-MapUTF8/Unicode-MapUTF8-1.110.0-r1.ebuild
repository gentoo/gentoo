# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Unicode-MapUTF8/Unicode-MapUTF8-1.110.0-r1.ebuild,v 1.2 2015/06/13 22:10:07 dilfridge Exp $

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
