# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=INGY
DIST_VERSION=0.25
inherit perl-module

DESCRIPTION="Extend File::ShareDir to local libraries"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~x86"
IUSE="test"

RDEPEND=">=dev-perl/File-ShareDir-1.30.0"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? ( virtual/perl-Test-Simple )
"
src_test() {
	perl_rm_files t/release-pod-syntax.t
	perl-module_src_test
}
