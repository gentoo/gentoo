# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=BRICAS
DIST_VERSION=1.13
inherit perl-module

DESCRIPTION="compiles CQL strings into parse trees of Node subtypes"
# Bug: https://bugs.gentoo.org/721472
LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Class-Accessor-0.100.0
	>=dev-perl/Clone-0.150.0
	>=dev-perl/String-Tokenizer-0.50.0
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	test? (
		dev-perl/Test-Exception
		virtual/perl-Test-Simple
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-1.13-no-dot-inc.patch"
)
