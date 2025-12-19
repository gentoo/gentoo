# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=EDAVIS
DIST_VERSION=1.4
inherit perl-module

DESCRIPTION="Logging/debugging aid"

SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ~riscv x86"

RDEPEND="
	>=dev-perl/HTML-FromText-1.4.0
"
BDEPEND="${RDEPEND}"

PATCHES=("${FILESDIR}/${P}-posix-tmpnam.patch")
