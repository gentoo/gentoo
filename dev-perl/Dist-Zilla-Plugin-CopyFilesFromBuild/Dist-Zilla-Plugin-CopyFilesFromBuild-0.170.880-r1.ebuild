# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RTHOMPSON
DIST_VERSION=0.170880
inherit perl-module

DESCRIPTION="Copy (or move) specific files after building (for SCM inclusion, etc.)"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/Dist-Zilla
	dev-perl/Moose
	dev-perl/MooseX-Has-Sugar
	dev-perl/Path-Tiny
	>=virtual/perl-Scalar-List-Utils-1.330.0
	dev-perl/Set-Scalar
"
BDEPEND="${RDEPEND}
	test? (
		dev-perl/Dist-Zilla-Plugin-ReadmeAnyFromPod
		dev-perl/Test-Exception
		dev-perl/Test-Most
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
