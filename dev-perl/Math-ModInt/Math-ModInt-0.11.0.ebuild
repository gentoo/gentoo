# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=MHASCH
DIST_VERSION=0.011

inherit perl-module

DESCRIPTION="modular integer arithmetic"

SLOT="0"
KEYWORDS="~amd64"
IUSE="minimal test"

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
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Scalar-List-Utils
		virtual/perl-Test
		virtual/perl-Test-Simple
	)
"
