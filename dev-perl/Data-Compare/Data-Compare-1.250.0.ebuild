# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=DCANTRELL
MODULE_VERSION=1.25
inherit perl-module

DESCRIPTION="Compare perl data structures"

SLOT="0"
KEYWORDS="amd64 hppa ~ppc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="test"

RDEPEND="
	>=dev-perl/File-Find-Rule-0.100.0
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Clone
		dev-perl/Scalar-Properties
	)
"

SRC_TEST="do"

src_test() {
	perl_rm_files t/pod.t
	perl-module_src_test
}
