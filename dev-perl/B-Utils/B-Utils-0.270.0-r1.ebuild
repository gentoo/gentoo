# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ETHER
DIST_VERSION=0.27
inherit perl-module

DESCRIPTION="Helper functions for op tree manipulation"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

# needs Scalar::Util
RDEPEND="
	virtual/perl-Exporter
	virtual/perl-Scalar-List-Utils
	dev-perl/Task-Weaken
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-CBuilder
	>=dev-perl/ExtUtils-Depends-0.301.0
	test? (
		virtual/perl-Test-Simple
	)
"
PERL_RM_FILES=(
	# These useless no-op tests that simply clutter test output
	t/utils/{31oldname,32kids,33ancestors,34descendants,35siblings,36previous,37stringify}.t
	t/utils/{41walkfilt,42all,43allfilt,44optrep}.t
	t/utils/{50carp,51croak}.t
)
