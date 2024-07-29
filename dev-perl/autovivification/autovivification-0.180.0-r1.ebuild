# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DIST_AUTHOR=VPIT
DIST_VERSION=0.18
DIST_EXAMPLES=("samples/*")
inherit perl-module

DESCRIPTION="Lexically disable autovivification"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="virtual/perl-XSLoader"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Exporter
		virtual/perl-Test-Simple
	)
"
src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
