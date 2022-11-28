# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MIYAGAWA
DIST_VERSION=0.03
inherit perl-module

DESCRIPTION="no capitalization on method names"

SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ~riscv sparc x86"

RDEPEND="dev-perl/Devel-Symdump"
BDEPEND="${RDEPEND}"
