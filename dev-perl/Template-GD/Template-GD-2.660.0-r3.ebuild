# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ABW
DIST_VERSION=2.66
inherit perl-module

DESCRIPTION="GD plugin(s) for the Template Toolkit"

SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="
	dev-perl/GD
	dev-perl/GDTextUtil
	dev-perl/GDGraph
	dev-perl/GD-Graph3d
	>=dev-perl/Template-Toolkit-2.150.0-r1
"
BDEPEND="${RDEPEND}
	test? ( dev-perl/GD[png(+)] )
"
