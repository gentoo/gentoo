# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=TONYC
MODULE_VERSION=0.006
inherit perl-module

DESCRIPTION="An XS implementation of POE::Queue::Array"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-perl/POE"
RDEPEND="${DEPEND}"

SRC_TEST="do"
