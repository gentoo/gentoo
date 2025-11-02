# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MAXMIND
DIST_VERSION=0.22
inherit perl-module

DESCRIPTION="Sane APIs for IP addresses and networks"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/List-AllUtils
	>=dev-perl/Math-Int128-0.60.0
	dev-perl/Moo
	>=virtual/perl-Socket-1.990.0
	dev-perl/Sub-Quote
	>=dev-perl/namespace-autoclean-0.160.0
"
BDEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.960.0
	)
"
PERL_RM_FILES=(
	"t/author-00-compile.t"
	"t/author-eol.t"
	"t/author-no-tabs.t"
	"t/author-pod-coverage.t"
	"t/author-pod-spell.t"
	"t/author-pod-syntax.t"
	"t/author-portability.t"
	"t/author-synopsis.t"
	"t/author-test-version.t"
	"t/release-cpan-changes.t"
	"t/release-tidyall.t"
)
