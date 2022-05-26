# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CADE
DIST_VERSION=1.8
inherit perl-module

DESCRIPTION="Patches text with given patch"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ~riscv x86"

RDEPEND="
	dev-perl/Text-Diff
"
BDEPEND="${RDEPEND}
"
