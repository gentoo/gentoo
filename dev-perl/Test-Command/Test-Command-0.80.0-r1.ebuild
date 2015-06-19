# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-Command/Test-Command-0.80.0-r1.ebuild,v 1.2 2015/06/13 21:51:40 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=DANBOO
MODULE_VERSION=0.08
inherit perl-module

DESCRIPTION="Test routines for external commands"

SLOT="0"
KEYWORDS="alpha amd64 ~arm ~mips ppc ppc64 sparc x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)"

SRC_TEST="do"
