# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/constant-boolean/constant-boolean-0.20.0-r1.ebuild,v 1.2 2015/06/13 21:48:42 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=DEXTER
MODULE_VERSION=0.02
inherit perl-module

DESCRIPTION="Define TRUE and FALSE constants"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/Symbol-Util"
DEPEND="dev-perl/Module-Build"

SRC_TEST=do
