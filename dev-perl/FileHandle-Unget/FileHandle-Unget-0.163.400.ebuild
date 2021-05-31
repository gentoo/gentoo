# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DCOPPIT
DIST_VERSION=0.1634
inherit perl-module

DESCRIPTION="A FileHandle which supports ungetting of multiple bytes"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ia64 ~ppc sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=virtual/perl-Scalar-List-Utils-1.140.0"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.360.0
	virtual/perl-File-Spec
	dev-perl/UNIVERSAL-require
	dev-perl/URI
	test? (
		dev-perl/File-Slurper
		dev-perl/Test-Compile
		virtual/perl-Test-Simple
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-0.1634-no-authortest-generation.patch"
)
