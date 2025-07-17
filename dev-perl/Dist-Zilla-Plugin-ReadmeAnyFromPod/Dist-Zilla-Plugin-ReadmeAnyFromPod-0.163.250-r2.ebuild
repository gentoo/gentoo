# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RTHOMPSON
DIST_VERSION=0.163250
inherit perl-module

DESCRIPTION="Automatically convert POD to a README in any format for Dist::Zilla"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/Dist-Zilla
	dev-perl/Dist-Zilla-Role-FileWatcher
	dev-perl/Moose
	dev-perl/MooseX-Has-Sugar
	dev-perl/PPI
	>=dev-perl/Path-Tiny-0.4.0
	>=dev-perl/Pod-Markdown-2.0.0
	dev-perl/Pod-Markdown-Github
	>=virtual/perl-Pod-Simple-3.230.0
	>=virtual/perl-Scalar-List-Utils-1.330.0
"
BDEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Deep
		dev-perl/Test-Fatal
		dev-perl/Test-Most
		dev-perl/Test-Requires
		>=virtual/perl-Test-Simple-0.940.0
	)
"

PERL_RM_FILES=(
	"t/author-critic.t"
	"t/author-pod-coverage.t"
	"t/author-pod-syntax.t"
	"t/release-has-version.t"
	"t/release-kwalitee.t"
	"t/release-portability.t"
	"t/release-unused-vars.t"
)
