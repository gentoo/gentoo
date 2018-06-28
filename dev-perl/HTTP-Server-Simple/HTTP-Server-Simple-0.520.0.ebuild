# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=BPS
DIST_VERSION=0.52
inherit perl-module

DESCRIPTION="Lightweight HTTP Server"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="test"

RDEPEND="
	dev-perl/CGI
	>=virtual/perl-Socket-1.940.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

src_test() {
	perl_rm_files t/02pod.t t/03podcoverage.t
	perl-module_src_test
}
