# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=PTC
DIST_VERSION=0.50
inherit perl-module

DESCRIPTION="Dispatcher module for command line interface programs"

SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="test"

PATCHES=("${FILESDIR}/${PN}-0.50-authortests.patch")
PERL_RM_FILES=(
	"t/03-pod.t"
	"t/99-kwalitee.t"
)

RDEPEND="
	dev-perl/Capture-Tiny
	virtual/perl-Carp
	dev-perl/Class-Load
	>=virtual/perl-Getopt-Long-2.350.0
	virtual/perl-Locale-Maketext-Simple
	virtual/perl-Pod-Simple
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
