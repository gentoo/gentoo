# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=ABW
MODULE_VERSION=2.66
inherit perl-module

DESCRIPTION="GD plugin(s) for the Template Toolkit"

SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~x86-fbsd ~x86-solaris"
IUSE="test"

RDEPEND="dev-perl/GD
	dev-perl/GDTextUtil
	dev-perl/GDGraph
	dev-perl/GD-Graph3d
	>=dev-perl/Template-Toolkit-2.15-r1"
DEPEND="${RDEPEND}
	test? ( dev-perl/GD[png] )"

SRC_TEST="do"
