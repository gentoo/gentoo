# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=RURBAN
DIST_VERSION=3.0239
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="cPanel fork of JSON::XS, fast and correct serializing"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~ppc64 ~x86"
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
