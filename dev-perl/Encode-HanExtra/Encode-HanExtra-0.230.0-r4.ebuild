# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=AUDREYT
DIST_VERSION=0.23
inherit perl-module

DESCRIPTION="Extra sets of Chinese encodings"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	>=virtual/perl-Encode-1.410.0
"
BDEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-0.23-no-dot-inc.patch"
)

src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
