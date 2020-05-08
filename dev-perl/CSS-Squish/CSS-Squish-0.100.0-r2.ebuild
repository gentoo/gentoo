# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=TSIBLEY
DIST_VERSION=0.10
inherit perl-module

DESCRIPTION="Compact many CSS files into one big file"
# License note: "perl 5.8.3 or later" bug https://bugs.gentoo.org/718946
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-File-Spec
	virtual/perl-Scalar-List-Utils
	dev-perl/URI
"
BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? (
		${RDEPEND}
		dev-perl/Test-LongString
	)
"
PERL_RM_FILES=(
	"t/99-pod-coverage.t"
	"t/99-pod.t"
)
