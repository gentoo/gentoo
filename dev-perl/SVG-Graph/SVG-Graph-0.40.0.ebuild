# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CJFIELDS
DIST_VERSION=0.04
inherit perl-module

DESCRIPTION="Visualize your data in Scalable Vector Graphics (SVG) format"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-perl/Math-Derivative
	dev-perl/Math-Spline
	dev-perl/Statistics-Descriptive
	dev-perl/SVG
	dev-perl/Tree-DAG_Node
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.360.100
"
