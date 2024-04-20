# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DIST_AUTHOR=DANIEL
inherit perl-module

DESCRIPTION="An OO interface to Musepack file information and APE tag fields"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# License note: says perl 5.8.2 or later

RDEPEND="
	>=dev-perl/Audio-Scan-0.850.0
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.420.0
"
PATCHES=(
	"${FILESDIR}/${PN}-1.0.1-no-dot-inc.patch"
)
PERL_RM_FILES=(
	"t/pod.t"
	"t/pod-coverage.t"
)
