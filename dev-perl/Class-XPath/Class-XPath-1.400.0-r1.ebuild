# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=SAMTREGAR
MODULE_VERSION=1.4
inherit perl-module

DESCRIPTION="adds xpath matching to object trees"

SLOT="0"
KEYWORDS="amd64 ia64 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="${RDEPEND}
	test? ( dev-perl/HTML-Tree )"

SRC_TEST="do"
