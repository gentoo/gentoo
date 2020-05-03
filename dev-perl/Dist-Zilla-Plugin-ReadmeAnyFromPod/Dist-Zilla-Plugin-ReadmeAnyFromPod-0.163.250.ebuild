# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=RTHOMPSON
DIST_VERSION=0.163250
inherit perl-module

DESCRIPTION="Automatically convert POD to a README in any format for Dist::Zilla"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Dist-Zilla
	dev-perl/Dist-Zilla-Role-FileWatcher
	virtual/perl-Encode
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
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Carp
		virtual/perl-File-Spec
		virtual/perl-IO
		dev-perl/Test-Deep
		dev-perl/Test-Fatal
		dev-perl/Test-Most
		dev-perl/Test-Requires
		>=virtual/perl-Test-Simple-0.940.0
		virtual/perl-autodie
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
