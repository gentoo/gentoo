# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=GRAY
DIST_VERSION=0.06
inherit perl-module

DESCRIPTION="Perl interface to the GOST R 34.11-94 digest algorithm"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

BDEPEND="
	test? (
		>=virtual/perl-Test-Simple-0.820.0
	)
"

PATCHES=(
	"${FILESDIR}/${P}-bigendian-link.patch"
)

src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
