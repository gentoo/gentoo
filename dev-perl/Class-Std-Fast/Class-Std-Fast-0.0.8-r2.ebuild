# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ACID
DIST_VERSION=v${PV}
inherit perl-module

DESCRIPTION="Faster but less secure than Class::Std"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Class-Std-0.11.0
	virtual/perl-version
	virtual/perl-Data-Dumper
	virtual/perl-Scalar-List-Utils
"
DEPEND="
	dev-perl/Module-Build
"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		virtual/perl-Test-Simple
	)
"
PERL_RM_FILES=(
	t/pod.t
	t/pod-coverage.t
	t/96_prereq_build.t
	t/97_kwalitee.t
)
