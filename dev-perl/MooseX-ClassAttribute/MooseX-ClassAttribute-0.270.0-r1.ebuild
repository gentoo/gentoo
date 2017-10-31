# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=DROLSKY
MODULE_VERSION=0.27
inherit perl-module

DESCRIPTION="Declare class attributes Moose-style"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/List-MoreUtils
	>=dev-perl/Moose-2.0.0
	>=dev-perl/namespace-autoclean-0.110.0
	>=dev-perl/namespace-clean-0.200.0"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.310.0
	test? ( >=virtual/perl-Test-Simple-0.880.0
		dev-perl/Test-Fatal
		>=dev-perl/Test-Requires-0.50.0 )"

SRC_TEST=do

src_test() {
	perl_rm_files t/release-*.t
	perl-module_src_test
}
