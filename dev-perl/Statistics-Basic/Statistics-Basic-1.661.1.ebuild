# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=JETTERO
DIST_VERSION=1.6611
inherit perl-module

DESCRIPTION="Statistics-Basic module"

SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="dev-perl/Number-Format"

SRC_TEST=do
