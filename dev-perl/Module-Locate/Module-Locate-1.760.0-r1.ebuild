# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Module-Locate/Module-Locate-1.760.0-r1.ebuild,v 1.1 2014/08/26 14:52:50 axs Exp $

EAPI=5

MODULE_AUTHOR=NEILB
MODULE_VERSION=1.76
inherit perl-module

DESCRIPTION="Locate modules in the same fashion as require and use"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

SRC_TEST="do"
