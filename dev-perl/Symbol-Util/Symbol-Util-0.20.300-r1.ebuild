# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Symbol-Util/Symbol-Util-0.20.300-r1.ebuild,v 1.2 2015/06/13 21:48:32 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=DEXTER
MODULE_VERSION=0.0203
inherit perl-module

DESCRIPTION="Additional utils for Perl symbols manipulation"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="dev-perl/Module-Build"

SRC_TEST=do
