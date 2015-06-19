# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Syntax-Highlight-Engine-Simple/Syntax-Highlight-Engine-Simple-0.80.0.ebuild,v 1.2 2015/06/13 22:05:01 dilfridge Exp $

EAPI=5

MODULE_VERSION=0.08
MODULE_AUTHOR=JAMADAM
inherit perl-module

DESCRIPTION="Simple Syntax Highlight Engine"
IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-perl/UNIVERSAL-require
	dev-perl/Module-Build"
