# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=GUGOD
MODULE_VERSION=0.34
inherit perl-module

DESCRIPTION="provides '\$self' in OO code"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-perl/B-Hooks-Parser-0.09
	>=dev-perl/PadWalker-1.9.2
	dev-perl/Sub-Exporter
	>=dev-perl/Devel-Declare-0.005005
	>=dev-perl/B-OPCheck-0.27"
RDEPEND="${DEPEND}"

SRC_TEST=do
