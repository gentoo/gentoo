# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/CryptX/CryptX-0.006.ebuild,v 1.3 2015/06/13 21:44:38 dilfridge Exp $

EAPI="5"
MODULE_AUTHOR="MIK"

inherit perl-module

DESCRIPTION="Self-contained crypto toolkit"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-perl/Module-Build"
