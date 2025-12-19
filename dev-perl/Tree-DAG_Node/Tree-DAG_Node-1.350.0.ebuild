# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RSAVAGE
DIST_A_EXT=tgz
DIST_VERSION=1.35
inherit perl-module

DESCRIPTION="(Super)class for representing nodes in a tree"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	>=dev-perl/File-Slurper-0.14.0
"
BDEPEND="${RDEPEND}"
