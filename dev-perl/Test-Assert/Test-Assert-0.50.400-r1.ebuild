# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-Assert/Test-Assert-0.50.400-r1.ebuild,v 1.2 2015/06/13 21:49:43 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=DEXTER
MODULE_VERSION=0.0504
inherit perl-module

DESCRIPTION="Assertion methods for those who like JUnit"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/constant-boolean
	>=dev-perl/Exception-Base-0.22.01
	dev-perl/Symbol-Util"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	dev-perl/Class-Inspector
	virtual/perl-parent
	>=dev-perl/Test-Unit-Lite-0.12"

SRC_TEST=do
