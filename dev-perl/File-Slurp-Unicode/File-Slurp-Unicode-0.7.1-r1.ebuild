# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/File-Slurp-Unicode/File-Slurp-Unicode-0.7.1-r1.ebuild,v 1.2 2015/06/13 22:48:16 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=DAVID
MODULE_VERSION=0.7.1
inherit perl-module

DESCRIPTION="Reading/Writing of Complete Files with Character Encoding Support"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-perl/File-Slurp
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
"

SRC_TEST=do
