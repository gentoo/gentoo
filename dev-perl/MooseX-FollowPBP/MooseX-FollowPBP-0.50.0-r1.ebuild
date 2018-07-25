# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DROLSKY
DIST_VERSION=0.05
inherit perl-module

DESCRIPTION="Name your accessors get_foo() and set_foo(), whatever that may mean"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~x86-fbsd"
IUSE="test"

RDEPEND="
	>=dev-perl/Moose-1.160.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.310.0
	test? ( >=virtual/perl-Test-Simple-0.880.0 )
"
src_test() {
	perl_rm_files t/release-*.t
	perl-module_src_test
}
