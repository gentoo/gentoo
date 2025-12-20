# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=IZUT
DIST_VERSION=3.03
inherit perl-module

DESCRIPTION="Simple date object"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ppc ~ppc64 ~riscv x86"

src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
