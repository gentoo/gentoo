# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CYCLES
DIST_VERSION=0.81
inherit perl-module

DESCRIPTION="Translate Wiki formatted text into other formats"

SLOT="0"
KEYWORDS="amd64 ~ppc ~riscv x86"

RDEPEND="
	dev-perl/URI
	virtual/perl-Scalar-List-Utils
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.28
"
