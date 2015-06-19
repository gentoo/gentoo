# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Tie-ToObject/Tie-ToObject-0.30.0-r1.ebuild,v 1.2 2015/06/13 11:39:30 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=NUFFIN
MODULE_VERSION=0.03
inherit perl-module

DESCRIPTION="Tie to an existing object"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~x64-macos"
IUSE="test"

RDEPEND=""
DEPEND="test? ( || ( >=virtual/perl-Test-Simple-1.1.10 dev-perl/Test-use-ok ) )"

SRC_TEST=do
