# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DCANTRELL
DIST_VERSION=1.27
inherit perl-module

DESCRIPTION="Compare perl data structures"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/File-Find-Rule-0.100.0
	virtual/perl-Scalar-List-Utils
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/Clone-0.430.0
		dev-perl/Scalar-Properties
		>=virtual/perl-Test-Simple-0.880.0
	)
"
PERL_RM_FILES=(
	"t/pod.t"
)
