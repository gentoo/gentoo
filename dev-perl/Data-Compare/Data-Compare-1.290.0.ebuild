# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DCANTRELL
DIST_VERSION=1.29
inherit perl-module

DESCRIPTION="Compare perl data structures"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="
	>=dev-perl/Clone-0.430.0
	>=dev-perl/File-Find-Rule-0.100.0
	virtual/perl-Scalar-List-Utils
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Scalar-Properties
		>=virtual/perl-Test-Simple-0.880.0
	)
"

PERL_RM_FILES=(
	"t/pod.t"
)
