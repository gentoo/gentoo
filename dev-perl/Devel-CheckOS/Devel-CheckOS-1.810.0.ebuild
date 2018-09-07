# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DCANTRELL
DIST_VERSION=1.81
inherit perl-module

DESCRIPTION="require that we are running on a particular OS"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Data-Compare-1.210.0
	>=dev-perl/File-Find-Rule-0.280.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-File-Temp-0.190.0
		>=virtual/perl-Test-Simple-0.880.0
	)
"
PERL_RM_FILES=(
	"t/63-kwalitee.t"
	"t/pod.t"
)
