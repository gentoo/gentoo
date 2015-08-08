# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
