# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=RCLAMP
MODULE_VERSION=0.23
inherit perl-module

DESCRIPTION="Checks if the documentation of a module is comprehensive"

SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND="
	>=virtual/perl-Pod-Parser-1.13
	>=dev-perl/Devel-Symdump-2.01
"
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST="do"

src_test() {
	perl_rm_files t/07pod.t
	perl-module_src_test
}
