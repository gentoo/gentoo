# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=EGILES
DIST_VERSION=v2.4.1
inherit perl-module

DESCRIPTION="Check whether Perl files compile correctly"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc sparc ~x86"
IUSE="minimal test"
RESTRICT="!test? ( test )"

RDEPEND="
	!minimal? (
		dev-perl/Devel-CheckOS
	)
	>=virtual/perl-Exporter-5.680.0
	dev-perl/UNIVERSAL-require
	>=virtual/perl-parent-0.225.0
	virtual/perl-version
"
DEPEND="dev-perl/Module-Build"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.380.0
	test? (
		dev-perl/Test-Exception
		dev-perl/Test-Warnings
		virtual/perl-Test-Simple
	)
"
PERL_RM_FILES=(
	t/999-has-version.t
	t/999-perlcritic.t
	t/999-pod-coverage.t
	t/999-pod.t
	t/999-portability.t
	t/999-synopsis.t
	t/999-version.t
)
