# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=RCLAMP
MODULE_VERSION=2.06
inherit perl-module

DESCRIPTION="Meatier versions of caller"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ~ia64 ppc ppc64 ~sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="dev-perl/PadWalker"
RDEPEND="${DEPEND}"

SRC_TEST=do
