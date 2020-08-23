# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=SAMTREGAR
DIST_VERSION=1.4
inherit perl-module

DESCRIPTION="adds xpath matching to object trees"

SLOT="0"
KEYWORDS="~amd64 ~ia64 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( dev-perl/HTML-Tree )"
