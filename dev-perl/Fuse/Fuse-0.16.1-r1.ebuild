# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=DPATES
inherit perl-module

DESCRIPTION="Fuse module for perl"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-fs/fuse:0="
DEPEND="${RDEPEND}"

# Test is whack - ChrisWhite
#SRC_TEST="do"
