# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=BDFOY
DIST_VERSION=20140910.003
inherit perl-module

DESCRIPTION="Data pack for Business::ISBN"

SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

PERL_RM_FILES=(
	"make_data.pl"
)
RDEPEND="
	virtual/perl-Carp
	virtual/perl-File-Spec
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
	test? (
		>=virtual/perl-Test-Simple-0.950.0
	)
"
src_test() {
	perl_rm_files t/pod{,_coverage}.t
	sed -r -i '/^pod(|_coverage)\.t$/d' "${S}/t/test_manifest" || die
	perl-module_src_test
}
