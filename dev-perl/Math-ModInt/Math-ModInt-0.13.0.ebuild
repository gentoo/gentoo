# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MHASCH
DIST_VERSION=0.013

inherit perl-module

DESCRIPTION="modular integer arithmetic"

SLOT="0"
KEYWORDS="~amd64"
IUSE="minimal"
LICENSE="Artistic-2"

PERL_RM_FILES=(
	"t/90_pod.t"
	"t/91_pod_cover_cp.t"
	"t/92_consistency.t"
	"t/93_examples.t"
	"t/95_versions.t"
	"t/99_signature.t"
)

RDEPEND="
	virtual/perl-Carp
	>=virtual/perl-Math-BigInt-1.991.0
	!minimal? (
		dev-perl/Math-BigInt-GMP
		virtual/perl-Math-BigRat
	)
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
	test? (
		virtual/perl-Scalar-List-Utils
		virtual/perl-Test
		virtual/perl-Test-Simple
	)
"
