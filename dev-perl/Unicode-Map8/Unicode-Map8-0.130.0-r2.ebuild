# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=GAAS
DIST_VERSION=0.13
inherit perl-module

DESCRIPTION="Convert between most 8bit encodings"

SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86"

RDEPEND="
	>=dev-perl/Unicode-String-2.60.0
"
BDEPEND="${RDEPEND}
"
