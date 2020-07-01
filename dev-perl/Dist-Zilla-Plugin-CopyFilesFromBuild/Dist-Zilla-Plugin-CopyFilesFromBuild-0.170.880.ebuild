# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=RTHOMPSON
DIST_VERSION=0.170880
inherit perl-module

DESCRIPTION="Copy (or move) specific files after building (for SCM inclusion, etc.)"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
RDEPEND="
	dev-perl/Dist-Zilla
	virtual/perl-IO
	dev-perl/Moose
	dev-perl/MooseX-Has-Sugar
	dev-perl/Path-Tiny
	>=virtual/perl-Scalar-List-Utils-1.330.0
	dev-perl/Set-Scalar
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Carp
		dev-perl/Dist-Zilla-Plugin-ReadmeAnyFromPod
		virtual/perl-File-Spec
		dev-perl/Test-Exception
		dev-perl/Test-Most
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
