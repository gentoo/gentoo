# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Linux-DesktopFiles/Linux-DesktopFiles-0.90.0.ebuild,v 1.2 2015/06/13 22:12:10 dilfridge Exp $

EAPI=5

MODULE_AUTHOR="TRIZEN"
MODULE_VERSION=0.09
inherit perl-module

DESCRIPTION="Perl module to get and parse the Linux .desktop files"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-lang/perl-5.14.0[gdbm]"
DEPEND="dev-perl/Module-Build"

SRC_TEST="do"
