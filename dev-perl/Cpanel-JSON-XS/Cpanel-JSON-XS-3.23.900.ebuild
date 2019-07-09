# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=RURBAN
DIST_VERSION=3.0239
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="cPanel fork of JSON::XS, fast and correct serializing"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv s390 ~sh sparc x86 ~ppc-aix ~amd64-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=virtual/perl-podlators-2.80.0
"
src_test() {
	perl_rm_files t/z_*.t
	perl-module_src_test
}
