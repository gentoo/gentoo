# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NEZUMI
DIST_VERSION=0.03
inherit perl-module

DESCRIPTION="An eucJP-open mapping"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	>=virtual/perl-Encode-1.140.0
"
BDEPEND="${RDEPEND}"

PERL_RM_FILES=(
	"t/pod.t"
)

src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
