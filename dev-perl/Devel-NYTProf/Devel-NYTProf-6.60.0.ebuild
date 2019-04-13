# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=TIMB
DIST_VERSION=6.06
DIST_EXAMPLES=("demo/*")
inherit perl-module

DESCRIPTION="Powerful feature-rich perl source code profiler"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/File-Which-1.90.0
	virtual/perl-Getopt-Long
	dev-perl/JSON-MaybeXS
	virtual/perl-Scalar-List-Utils
	virtual/perl-XSLoader
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.840.0
		>=dev-perl/Test-Differences-0.60.0
	)
"
PERL_RM_FILES=(
	t/68-hashline.t
	t/71-moose.t
	t/72-autodie.t
	t/90-pod.t
	t/91-pod_coverage.t
	t/92-file_port.t
)
