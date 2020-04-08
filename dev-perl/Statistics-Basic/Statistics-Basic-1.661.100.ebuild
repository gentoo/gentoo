# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=JETTERO
DIST_VERSION=1.6611
inherit perl-module

DESCRIPTION="A collection of very basic statistics modules"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Number-Format-1.420.0
	virtual/perl-Scalar-List-Utils
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
PATCHES=(
	"${FILESDIR}/${PN}-${DIST_VERSION}-no-dot-inc.patch"
)
PERL_RM_FILES=(
	"t/pod_coverage.t"
	"t/pod.t"
	"t/critic.t"
)
