# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=BDFOY
DIST_VERSION=20191107
inherit perl-module

DESCRIPTION="Data pack for Business::ISBN"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
LICENSE="Artistic-2"
IUSE="test"
RESTRICT="!test? ( test )"

PERL_RM_FILES=(
	"make_data.pl"
	"t/pod.t"
	"t/pod_coverage.t"
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
src_prepare() {
	sed -r -i '/^pod(|_coverage)\.t$/d' "${S}/t/test_manifest" || die
	perl-module_src_prepare
}
