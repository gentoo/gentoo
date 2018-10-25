# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=PEVANS
MODULE_VERSION=0.10
inherit perl-module

DESCRIPTION="Higher-order list utility functions"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

DEPEND="
	>=dev-perl/Module-Build-0.380.0
	test? ( virtual/perl-Test-Simple )
"
PATCHES=("${FILESDIR}/${P}-no-dot-inc.patch")
SRC_TEST=do

src_test() {
	perl_rm_files t/99pod.t
	perl-module_src_test
}
