# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/self/self-0.340.0-r1.ebuild,v 1.1 2014/08/26 18:06:02 axs Exp $

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
