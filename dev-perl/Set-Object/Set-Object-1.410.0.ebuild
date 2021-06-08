# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=RURBAN
DIST_VERSION=1.41
inherit perl-module

DESCRIPTION="set of objects and strings"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Scalar-List-Utils
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

PERL_RM_FILES=(
	"t/misc/kwalitee.t"
	"t/misc/meta.t"
	"t/misc/manifest.t"
	"t/misc/perl_minimum_version.t"
	"t/misc/pod.t"
	"t/misc/pod_coverage.t"
)
