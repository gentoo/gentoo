# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MVERB
DIST_VERSION=0.86
DIST_EXAMPLES=( "demo/*" )
inherit perl-module

DESCRIPTION="Text utilities for use with GD"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-solaris"
IUSE=""

RDEPEND="dev-perl/GD"
DEPEND="${RDEPEND}"
