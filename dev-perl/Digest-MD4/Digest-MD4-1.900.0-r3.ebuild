# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MIKEM
DIST_VERSION=1.9
DIST_SECTION=DigestMD4
inherit perl-module

DESCRIPTION="MD4 message digest algorithm"
LICENSE="|| ( Artistic GPL-1+ ) RSA"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~m68k ~mips ppc ppc64 ~s390 sparc x86"

src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
