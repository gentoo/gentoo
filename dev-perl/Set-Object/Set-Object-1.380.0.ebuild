# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=RURBAN
DIST_VERSION=1.38
inherit perl-module

DESCRIPTION="set of objects and strings"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
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
PATCHES=(
	"${FILESDIR}/${PN}-1.38-no-changes-pod.patch"
)
