# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=JAMADAM
MODULE_VERSION=0.02

inherit perl-module

DESCRIPTION="Experimental Perl code highlighting class"

IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/Syntax-Highlight-Engine-Simple-0.80.0
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
"
