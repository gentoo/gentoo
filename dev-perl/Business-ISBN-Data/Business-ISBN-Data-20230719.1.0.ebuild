# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BDFOY
DIST_VERSION=20230719.001
inherit perl-module

DESCRIPTION="Data pack for Business::ISBN"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~riscv ~x86"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-File-Spec
"
DEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
	test? (
		>=virtual/perl-Test-Simple-1
	)
"

PERL_RM_FILES=(
	"make_data.pl"
	"t/pod.t"
	"t/pod_coverage.t"
)

src_prepare() {
	sed -r -i '/^pod(|_coverage)\.t$/d' "${S}/t/test_manifest" || die
	perl-module_src_prepare
}
