# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=JJSCHUTZ
DIST_VERSION=0.10
inherit perl-module

DESCRIPTION="Sphinx search engine configuration file read/modify/write"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	dev-perl/List-MoreUtils
	virtual/perl-Storable
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

src_test() {
	perl_rm_files "t/pod-coverage.t" "t/boilerplate.t" "t/pod.t"
	perl-module_src_test
}
