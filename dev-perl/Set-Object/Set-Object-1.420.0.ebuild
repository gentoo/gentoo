# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RURBAN
DIST_VERSION=1.42
inherit perl-module

DESCRIPTION="Set of objects and strings"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc sparc x86"

RDEPEND="
	virtual/perl-Scalar-List-Utils
"
BDEPEND="
	${RDEPEND}
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
