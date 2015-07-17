# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Devel-SmallProf/Devel-SmallProf-2.20.0-r2.ebuild,v 1.1 2015/07/17 19:06:48 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=SALVA
MODULE_VERSION=2.02
inherit perl-module

DESCRIPTION="Per-line Perl profiler"

SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""

PATCHES=(
	"${FILESDIR}/${P}-defined.patch"
)

SRC_TEST="do"
# note: dont use parallel here
