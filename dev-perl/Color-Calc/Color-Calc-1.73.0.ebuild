# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=CFAERBER
MODULE_VERSION=1.073
inherit perl-module

DESCRIPTION='Simple calculations with RGB colors'

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND=">=dev-perl/Graphics-ColorNames-2.100.0
	>=dev-perl/Graphics-ColorNames-WWW-0.10.0
	>=dev-perl/Graphics-ColorObject-0.5.0
	>=dev-perl/Params-Validate-0.75"

DEPEND="${RDEPEND}
	dev-perl/Test-NoWarnings
	>=dev-perl/Module-Build-0.380.0
	virtual/perl-Test-Simple
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)"

SRC_TEST="do"
