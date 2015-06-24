# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Term-Screen/Term-Screen-1.30.0-r1.ebuild,v 1.2 2015/06/24 14:24:11 monsieurp Exp $

EAPI=5

MODULE_AUTHOR=JSTOWE
MODULE_VERSION=1.03
inherit perl-module

DESCRIPTION="A simple Term::Cap based screen positioning module"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

# Tests are interactive
#SRC_TEST="do"
