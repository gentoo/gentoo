# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MVERB
DIST_VERSION=0.86
DIST_EXAMPLES=( "demo/*" )
inherit perl-module

DESCRIPTION="Text utilities for use with GD"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x86-solaris"

RDEPEND="
	dev-perl/GD
"
BDEPEND="${RDEPEND}
"
