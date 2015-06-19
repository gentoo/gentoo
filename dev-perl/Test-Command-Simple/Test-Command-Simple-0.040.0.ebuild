# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-Command-Simple/Test-Command-Simple-0.040.0.ebuild,v 1.2 2015/06/13 21:51:58 dilfridge Exp $

EAPI="5"

MODULE_AUTHOR="DMCBRIDE"
MODULE_VERSION=0.04

inherit perl-module

DESCRIPTION="Test external commands (nearly) as easily as loaded modules"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="dev-perl/Module-Build
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)"
RDEPEND=""

SRC_TEST="do"
