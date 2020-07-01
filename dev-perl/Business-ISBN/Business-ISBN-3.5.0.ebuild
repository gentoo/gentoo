# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=BDFOY
DIST_VERSION=3.005
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Work with ISBN as objects"
LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="test barcode"
RESTRICT="!test? ( test )"

RDEPEND="
	barcode? (
		dev-perl/GD-Barcode
		dev-perl/GD[png]
	)
	>=dev-perl/Business-ISBN-Data-20191107.0.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.950.0
	)
"
PERL_RM_FILES=(
	"t/pod.t"
	"t/pod_coverage.t"
)
src_prepare() {
	sed -i -e '/^pod\.t/d;/^pod_coverage\.t/d' t/test_manifest || die "Can't fix test_manifest"
	perl-module_src_prepare
}
