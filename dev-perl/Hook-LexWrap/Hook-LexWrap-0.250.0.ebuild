# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=ETHER
MODULE_VERSION=0.25
inherit perl-module

DESCRIPTION="Lexically scoped subroutine wrappers"

SLOT="0"
KEYWORDS="alpha amd64 ~arm ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/Module-Build-Tiny-0.39.0
	test? (
		virtual/perl-File-Spec
		virtual/perl-Test-Simple
	)
"

SRC_TEST="do parallel"

src_test() {
	perl_rm_files t/pod.t
	perl-module_src_test
}
