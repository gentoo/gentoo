# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BPS
DIST_VERSION=0.52
inherit perl-module

DESCRIPTION="Lightweight HTTP Server"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	dev-perl/CGI
	>=virtual/perl-Socket-1.940.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

src_test() {
	perl_rm_files t/02pod.t t/03podcoverage.t
	perl-module_src_test
}
