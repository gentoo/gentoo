# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/MooseX-Object-Pluggable/MooseX-Object-Pluggable-0.1.100-r1.ebuild,v 1.2 2015/06/13 18:53:05 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=GRODITI
MODULE_VERSION=0.0011
inherit perl-module

DESCRIPTION="Make your classes pluggable"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="test"

RDEPEND="dev-perl/Module-Pluggable
	dev-perl/Moose"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)"

SRC_TEST=do
