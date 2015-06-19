# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/maybe/maybe-0.20.200-r1.ebuild,v 1.2 2015/06/13 22:20:25 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=DEXTER
MODULE_VERSION=0.0202
inherit perl-module

DESCRIPTION="Use a Perl module and ignore error if can't be loaded"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-perl/Module-Build"

SRC_TEST=do
