# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DPARIS
DIST_VERSION=2.07
inherit perl-module

DESCRIPTION="Perl DES encryption module"

LICENSE="DES"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv ~sparc x86 ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? ( dev-perl/Crypt-CBC )
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.07-implicit-func-decl.patch
)

src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
