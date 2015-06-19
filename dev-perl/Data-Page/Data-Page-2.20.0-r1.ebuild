# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Data-Page/Data-Page-2.20.0-r1.ebuild,v 1.2 2015/06/13 22:32:58 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=LBROCARD
MODULE_VERSION=2.02
inherit perl-module

DESCRIPTION="help when paging through sets of results"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-aix ~x86-solaris"
IUSE="test"

RDEPEND="dev-perl/Class-Accessor-Chained"
DEPEND="dev-perl/Module-Build
	test? (
		${RDEPEND}
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
		dev-perl/Test-Exception
	)"

SRC_TEST=do
