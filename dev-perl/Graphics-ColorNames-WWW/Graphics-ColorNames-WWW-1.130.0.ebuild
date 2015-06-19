# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Graphics-ColorNames-WWW/Graphics-ColorNames-WWW-1.130.0.ebuild,v 1.2 2015/06/13 21:40:46 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=CFAERBER
MODULE_VERSION=1.13
inherit perl-module

DESCRIPTION="WWW color names and equivalent RGB values"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=dev-perl/Graphics-ColorNames-0.320.0"
DEPEND="${RDEPEND}
	virtual/perl-Test-Simple
	dev-perl/Test-NoWarnings
	dev-perl/Module-Build
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)"

SRC_TEST="do"
