# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ISHIGAKI
DIST_VERSION=4.10
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="JSON (JavaScript Object Notation) encoder/decoder"

SLOT="0"
KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="test +xs"
RESTRICT="!test? ( test )"

RDEPEND="xs? ( >=dev-perl/JSON-XS-2.340.0 )"
BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

src_test() {
	perl_rm_files t/00_pod.t
	perl-module_src_test
}
